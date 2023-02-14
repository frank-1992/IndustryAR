//
//  VideoSettings.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import AVFoundation

@available(iOS 11.0, *)
public struct VideoSettings {

  /// The type of the output video file.
  public var fileType: FileType = .mov

  /// The codec used to encode the output video.
  public var codec: Codec = .h264()

  /// The size of the output video.
  ///
  /// If `nil` the size of the video source will be used.
  /// Look at `ScalingMode` for possible scaling modes.
  public var size: CGSize?

  public var scalingMode: ScalingMode = .resizeAspectFill

  /// The transform applied to video frames
  ///
  /// If `nil` an appropriate transform will be applied.
  /// Be carefull, the value is not always obvious.
  public var transform: CGAffineTransform?

  var videoColorProperties: [String: String]?

  public init(
    fileType: FileType = .mov,
    codec: Codec = .h264(),
    size: CGSize? = nil,
    scalingMode: ScalingMode = .resizeAspectFill,
    transform: CGAffineTransform? = nil
  ) {
    self.fileType = fileType
    self.codec = codec
    self.size = size
    self.scalingMode = scalingMode
    self.transform = transform
  }
}

@available(iOS 11.0, *)
extension VideoSettings {

  var outputSettings: [String: Any] {
    return ([
      AVVideoWidthKey: size?.width,
      AVVideoHeightKey: size?.height,
      AVVideoCodecKey: codec.avCodec,
      AVVideoScalingModeKey: scalingMode.avScalingMode,
      AVVideoColorPropertiesKey: videoColorProperties,
      AVVideoCompressionPropertiesKey: codec.compressionProperties
    ] as [String: Any?]).compactMapValues({ $0 })
  }
}
