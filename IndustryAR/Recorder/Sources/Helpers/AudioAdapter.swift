//
//  AudioAdapter.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/7/22.
//

import Foundation
import AVFoundation

final class AudioAdapter: NSObject, AVCaptureAudioDataOutputSampleBufferDelegate {

  typealias Callback = (_ sampleBuffer: CMSampleBuffer) -> Void

  let output: AVCaptureAudioDataOutput

  let queue: DispatchQueue

  let callback: Callback

  init(queue: DispatchQueue, callback: @escaping Callback) {
    self.queue = queue
    self.callback = callback
    output = AVCaptureAudioDataOutput()

    super.init()
    output.setSampleBufferDelegate(self, queue: queue)
  }

  @objc func captureOutput(
    _ output: AVCaptureOutput,
    didOutput sampleBuffer: CMSampleBuffer,
    from connection: AVCaptureConnection
  ) {
    callback(sampleBuffer)
  }
}
