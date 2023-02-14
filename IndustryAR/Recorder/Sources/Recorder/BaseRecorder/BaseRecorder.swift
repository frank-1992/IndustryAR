//
//  BaseRecorder.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import SceneKit
import ARKit

@available(iOS 11.0, *)
public class BaseRecorder: NSObject {

  let mediaSession: MediaSession

  var hasAudioInput = false

  lazy var audioInput: AudioInput = {
    let audioInput = AudioInput(queue: queue)
    hasAudioInput = true
    mediaSession.setAudioInput(audioInput)
    return audioInput
  }()

  let queue: DispatchQueue

  @Observable public internal(set) var error: Swift.Error?

  public var useAudioEngine: Bool {
    get { audioInput.useAudioEngine }
    set { audioInput.useAudioEngine = newValue }
  }

  init(queue: DispatchQueue, mediaSession: MediaSession) {
    self.queue = queue
    self.mediaSession = mediaSession
    super.init()
    self.mediaSession.$error.observe { [weak self] in self?.error = $0 }
  }

  public func makeVideoRecording(
    to url: URL,
    videoSettings: VideoSettings,
    audioSettings: AudioSettings?
  ) throws -> VideoRecording {
    try mediaSession.makeVideoRecording(
      to: url,
      videoSettings: videoSettings,
      audioSettings: audioSettings
    )
  }

  public func capturePixelBuffers(
    handler: @escaping (CVPixelBuffer, CMTime) -> Void
  ) -> PixelBufferOutput {
    mediaSession.capturePixelBuffers(handler: handler)
  }

  public func takePhoto(
    scale: CGFloat,
    orientation: UIImage.Orientation?,
    handler: @escaping (Result<UIImage, Swift.Error>) -> Void
  ) {
    mediaSession.takePhoto(
      scale: scale,
      orientation: orientation,
      handler: handler
    )
  }

  public func takeCoreImage(handler: @escaping (Result<CIImage, Swift.Error>) -> Void) {
    mediaSession.takeCoreImage(handler: handler)
  }

  public func takePixelBuffer(handler: @escaping (Result<CVPixelBuffer, Swift.Error>) -> Void) {
    mediaSession.takePixelBuffer(handler: handler)
  }
}

// MARK: - ARSessionDelegate
@available(iOS 11.0, *)
extension BaseRecorder: ARSessionDelegate {

  @objc public func session(
    _ session: ARSession,
    didOutputAudioSampleBuffer audioSampleBuffer: CMSampleBuffer
  ) {
    audioInput.session(session, didOutputAudioSampleBuffer: audioSampleBuffer)
  }
}
