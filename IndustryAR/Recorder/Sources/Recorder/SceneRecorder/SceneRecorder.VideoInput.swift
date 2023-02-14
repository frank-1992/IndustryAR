//
//  SceneRecorder.VideoInput.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import AVFoundation
import SceneKit

@available(iOS 11.0, *)
extension SceneRecorder {

  final class VideoInput: MediaSessionInput_PixelBufferVideo, TimeScalable {

    enum Error: Swift.Error {

      case recordableLayer
    }

    let timeScale: CMTimeScale

    let producer: MetalPixelBufferProducer

    lazy var size: CGSize = producer.recordableLayer.drawableSize

    var videoColorProperties: [String: String]? { producer.videoColorProperties }

    var videoTransform: CGAffineTransform { producer.videoTransform }

    var imageOrientation: UIImage.Orientation { producer.imageOrientation }

    var output: ((CVBuffer, CMTime) -> Void)?

    @UnfairAtomic var started: Bool = false

    init(recordable: MetalRecordable, timeScale: CMTimeScale, queue: DispatchQueue) throws {
      guard let recordableLayer = recordable.recordableLayer else { throw Error.recordableLayer }

      self.timeScale = timeScale
      self.producer = try MetalPixelBufferProducer(recordableLayer: recordableLayer, queue: queue)
    }

    func start() { started = true }

    func render(
      atTime time: TimeInterval,
      error errorHandler: @escaping (Swift.Error) -> Void
    ) throws {
      size = (producer.recordableLayer.lastTexture?.iosurface as IOSurface?)?.size ?? size

      guard started, let output = output else { return }

      let time = timeFromSeconds(time)
      try producer.produce { [output] (result) in
        switch result {
        case .success(let pixelBuffer): output(pixelBuffer, time)
        case .failure(let error): errorHandler(error)
        }
      }
    }

    func render(
      atTime time: TimeInterval,
      using commandQueue: MTLCommandQueue,
      error errorHandler: @escaping (Swift.Error) -> Void
    ) throws {
      size = (producer.recordableLayer.lastTexture?.iosurface as IOSurface?)?.size ?? size

      guard started, let output = output else { return }

      let time = timeFromSeconds(time)
      try producer.produce(using: commandQueue) { [output] (result) in
        switch result {
        case .success(let pixelBuffer): output(pixelBuffer, time)
        case .failure(let error): errorHandler(error)
        }
      }
    }

    func stop() { started = false }
  }
}
