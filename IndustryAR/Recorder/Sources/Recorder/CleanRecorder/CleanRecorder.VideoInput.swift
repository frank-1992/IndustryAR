//
//  CleanRecorder.VideoInput.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import AVFoundation
import SceneKit

@available(iOS 11.0, *)
extension CleanRecorder {

  final class VideoInput<T: CleanRecordable>: MediaSessionInput_PixelBufferVideo, TimeScalable {

    weak var cleanRecordable: T?

    let timeScale: CMTimeScale

    let queue: DispatchQueue

    var size: CGSize {
      guard let buffer = cleanRecordable?.cleanPixelBuffer else { return .zero }
      return CGSize(
        width: CVPixelBufferGetWidth(buffer),
        height: CVPixelBufferGetHeight(buffer)
      )
    }

    var videoColorProperties: [String: String]? { nil }

    var videoTransform: CGAffineTransform { .identity }

    var imageOrientation: UIImage.Orientation { .up }

    lazy var pixelBufferPoolFactory = PixelBufferPoolFactory.getWeaklyShared()

    let context: CIContext = MTLCreateSystemDefaultDevice()
      .map({ CIContext(mtlDevice: $0 )}) ?? CIContext()

    var output: ((CVBuffer, CMTime) -> Void)?

    @UnfairAtomic var started: Bool = false

    init(cleanRecordable: T, timeScale: CMTimeScale, queue: DispatchQueue) {
      self.cleanRecordable = cleanRecordable
      self.timeScale = timeScale
      self.queue = queue
    }

    func start() { started = true }

    func stop() { started = false }

    func render(atTime time: TimeInterval) throws {
      guard started, let output = output else { return }
      guard let pixelBuffer = cleanRecordable?.cleanPixelBuffer else { return }

      let time = timeFromSeconds(time)
      queue.async { output(pixelBuffer, time) }
    }
  }
}
