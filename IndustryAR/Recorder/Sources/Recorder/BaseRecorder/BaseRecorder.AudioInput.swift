//
//  BaseRecorder.AudioInput.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import AVFoundation
import ARKit

@available(iOS 11.0, *)
extension BaseRecorder {

  final class AudioInput: NSObject, MediaSessionInput_SampleBufferAudio {

    let queue: DispatchQueue

    let captureOutput = AVCaptureAudioDataOutput()

    var audioFormat: AVAudioFormat?

    @UnfairAtomic var started: Bool = false

    @ReadWriteAtomic var useAudioEngine: Bool = false

    var output: ((CMSampleBuffer) -> Void)?

    init(queue: DispatchQueue) {
      self.queue = queue
      super.init()
      self.captureOutput.setSampleBufferDelegate(self, queue: queue)
    }

    func start() { started = true }

    func stop() { started = false }

    func recommendedAudioSettingsForAssetWriter(
      writingTo outputFileType: AVFileType
    ) -> [String: Any] {
      audioFormat.map { AudioSettings(audioFormat: $0).outputSettings }
        ?? captureOutput.recommendedAudioSettingsForAssetWriter(writingTo: outputFileType)
        ?? AudioSettings().outputSettings
    }
  }
}

@available(iOS 11.0, *)
extension BaseRecorder.AudioInput: AVCaptureAudioDataOutputSampleBufferDelegate {

  @objc func captureOutput(
    _ output: AVCaptureOutput,
    didOutput sampleBuffer: CMSampleBuffer,
    from connection: AVCaptureConnection
  ) {
    guard started, !useAudioEngine else { return }
    self.output?(sampleBuffer)
  }
}

@available(iOS 11.0, *)
extension BaseRecorder.AudioInput: ARSessionObserver {

  func session(
    _ session: ARSession,
    didOutputAudioSampleBuffer audioSampleBuffer: CMSampleBuffer
  ) {
    guard started, !useAudioEngine else { return }
    queue.async { [output] in output?(audioSampleBuffer) }
  }
}

@available(iOS 13.0, *)
extension BaseRecorder.AudioInput {

  func audioEngine(
    _ audioEngine: AudioEngine,
    didOutputAudioSampleBuffer audioSampleBuffer: CMSampleBuffer
  ) {
    guard started, useAudioEngine else { return }
    queue.async { [output] in output?(audioSampleBuffer) }
  }
}
