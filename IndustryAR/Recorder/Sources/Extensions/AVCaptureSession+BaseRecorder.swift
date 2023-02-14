//
//  AVCaptureSession+BaseRecorder.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import AVFoundation

@available(iOS 11.0, *)
public extension AVCaptureSession {

  enum MakeError: Swift.Error {

    case defaultDeviceNotFound(type: AVMediaType)

    case canNotAddInput(input: AVCaptureInput)

    case canNotAddRecorder(recorder: BaseRecorder)
  }

  static func makeAudioForRecorder(
    _ recorder: BaseRecorder
  ) throws -> AVCaptureSession {
    let captureSession = AVCaptureSession()

    let mediaType = AVMediaType.audio
    guard let captureDevice = AVCaptureDevice.default(for: mediaType) else {
      throw MakeError.defaultDeviceNotFound(type: mediaType)
    }

    let captureInput = try AVCaptureDeviceInput(device: captureDevice)

    guard captureSession.canAddInput(captureInput) else {
      throw MakeError.canNotAddInput(input: captureInput)
    }

    captureSession.addInput(captureInput)

    guard captureSession.canAddRecorder(recorder) else {
      throw MakeError.canNotAddRecorder(recorder: recorder)
    }

    captureSession.addRecorder(recorder)
    return captureSession
  }

  func canAddRecorder(_ recorder: BaseRecorder) -> Bool {
    return canAddOutput(recorder.audioInput.captureOutput)
  }

  func addRecorder(_ recorder: BaseRecorder) {
    addOutput(recorder.audioInput.captureOutput)
  }

  func removeRecorder(_ recorder: BaseRecorder) {
    guard recorder.hasAudioInput else { return }
    removeOutput(recorder.audioInput.captureOutput)
  }
}
