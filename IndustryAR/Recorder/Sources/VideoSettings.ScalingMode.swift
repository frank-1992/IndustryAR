//
//  VideoSettings.ScalingMode.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import AVFoundation

@available(iOS 11.0, *)
public extension VideoSettings {

  enum ScalingMode {

    /// Crop to remove edge processing region.
    /// Preserve aspect ratio of cropped source by reducing specified width or height if necessary.
    /// Will not scale a small source up to larger dimensions.
//    case fit

    /// Crop to remove edge processing region.
    /// Scale remainder to destination area.
    /// Does not preserve aspect ratio.
    case resize

    /// Preserve aspect ratio of the source, and fill remaining areas with black to fit destination dimensions.
    case resizeAspect

    /// Preserve aspect ratio of the source, and crop picture to fit destination dimensions.
    case resizeAspectFill
  }
}
@available(iOS 11.0, *)
extension VideoSettings.ScalingMode {

  var avScalingMode: String {
    switch self {
//    case .fit: return AVVideoScalingModeFit
    case .resize: return AVVideoScalingModeResize
    case .resizeAspect: return AVVideoScalingModeResizeAspect
    case .resizeAspectFill: return AVVideoScalingModeResizeAspectFill
    }
  }
}
