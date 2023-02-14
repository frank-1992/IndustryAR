//
//  SelfRecordable.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import UIKit
import AVFoundation
import SceneKit
import ARKit

private var videoRecordingKey: UInt8 = 0

public enum SelfRecordableError: Swift.Error {
  case recorderNotInjected
  case videoRecordingAlreadyStarted
}

@available(iOS 11.0, *)
public protocol SelfRecordable: AnyObject {

  typealias Recorder = (BaseRecorder & Renderable)

  var recorder: Recorder? { get }

  var videoRecording: VideoRecording? { get set }

  func prepareForRecording()

  func injectRecorder()
}

@available(iOS 11.0, *)
public extension SelfRecordable {

  private var videoRecordingStorage: AssociatedStorage<VideoRecording> {
    AssociatedStorage(object: self, key: &videoRecordingKey, policy: .OBJC_ASSOCIATION_RETAIN)
  }

  var videoRecording: VideoRecording? {
    get { videoRecordingStorage.get() }
    set { videoRecordingStorage.set(newValue) }
  }
}

@available(iOS 11.0, *)
extension SelfRecordable {

  func assertedRecorder(
    file: StaticString = #file,
    line: UInt = #line
  ) -> Recorder {
    assert(
      recorder != nil,
      "Please call prepareForRecording() at viewDidLoad!",
      file: file,
      line: line
    )
    // swiftlint:disable force_unwrapping
    return recorder!
  }
}

@available(iOS 11.0, *)
public extension SelfRecordable {

  func prepareForRecording() {
    guard recorder == nil else { return }
    injectRecorder()
    assert(recorder != nil)

    fixFirstLaunchFrameDrop()
  }

  // Time to time, when the first video recording is started
  // There is a small frame drop for a half of a second.
  // It happens because the first AVAssetWriter initialization takes longer that continues.
  // But reusable IOSurfaces are already captured by SCNRecorder and SceneKit can't fastly acquire them.
  // This is probably a temporary fix until I find a better one.
  // - Vlad
  internal func fixFirstLaunchFrameDrop() {
    let queue = DispatchQueue(label: "SCNRecorder.Temporarty.DispatchQueue")
    queue.async {

      var videoSettings = VideoSettings()
      videoSettings.size = CGSize(width: 1024, height: 768)

      let url = FileManager.default.temporaryDirectory.appendingPathComponent(
        "\(UUID().uuidString).\(videoSettings.fileType.fileExtension)",
        isDirectory: false
      )

      let videoOutput = try? VideoOutput(
        url: url,
        videoSettings: videoSettings,
        audioSettings: AudioSettings().outputSettings,
        queue: queue
      )

      queue.async { videoOutput?.cancel() }
      queue.async { try? FileManager.default.removeItem(at: url) }
    }
  }
}

@available(iOS 11.0, *)
public extension SelfRecordable where Self: MetalRecordable {

  func prepareForRecording() {
    recordableLayer?.prepareForRecording()

    guard recorder == nil else { return }
    injectRecorder()
    assert(recorder != nil)

    fixFirstLaunchFrameDrop()
  }
}

@available(iOS 11.0, *)
public extension SelfRecordable {

  @discardableResult
  func startVideoRecording(
    fileType: VideoSettings.FileType = .mov,
    size: CGSize? = nil
  ) throws -> VideoRecording {
    try startVideoRecording(videoSettings: VideoSettings(fileType: fileType, size: size))
  }

  func capturePixelBuffers(
    handler: @escaping (CVPixelBuffer, CMTime) -> Void
  ) -> PixelBufferOutput {
    assertedRecorder().capturePixelBuffers(handler: handler)
  }

  @discardableResult
  func startVideoRecording(
    to url: URL,
    fileType: VideoSettings.FileType = .mov,
    size: CGSize? = nil
  ) throws -> VideoRecording {
    try startVideoRecording(to: url, videoSettings: VideoSettings(fileType: fileType, size: size))
  }

  @discardableResult
  func startVideoRecording(
    videoSettings: VideoSettings,
    audioSettings: AudioSettings? = nil
  ) throws -> VideoRecording {
    return try startVideoRecording(
      to: FileManager.default.temporaryDirectory.appendingPathComponent(
        "\(UUID().uuidString).\(videoSettings.fileType.fileExtension)",
        isDirectory: false
      ),
      videoSettings: videoSettings,
      audioSettings: audioSettings
    )
  }

  @discardableResult
  func startVideoRecording(
    to url: URL,
    videoSettings: VideoSettings,
    audioSettings: AudioSettings? = nil
  ) throws -> VideoRecording {
    guard videoRecording == nil else { throw SelfRecordableError.videoRecordingAlreadyStarted }

    let videoRecording = try assertedRecorder().makeVideoRecording(
      to: url,
      videoSettings: videoSettings,
      audioSettings: audioSettings
    )
    videoRecording.resume()

    self.videoRecording = videoRecording
    return videoRecording
  }

  func finishVideoRecording(completionHandler handler: @escaping (VideoRecording.Info) -> Void) {
    videoRecording?.finish { videoRecordingInfo in
      DispatchQueue.main.async { handler(videoRecordingInfo) }
    }
    videoRecording = nil
  }

  func cancelVideoRecording() {
    videoRecording?.cancel()
    videoRecording = nil
  }

  func takePhoto(
    scale: CGFloat = UIScreen.main.scale,
    orientation: UIImage.Orientation? = nil,
    completionHandler handler: @escaping (UIImage) -> Void
  ) {
    takePhotoResult(
      scale: scale,
      orientation: orientation
    ) {
      do { try handler($0.get()) }
      catch { assertionFailure("\(error)") }
    }
  }

  func takePhotoResult(
    scale: CGFloat = UIScreen.main.scale,
    orientation: UIImage.Orientation? = nil,
    handler: @escaping (Result<UIImage, Swift.Error>) -> Void
  ) {
    assertedRecorder().takePhoto(scale: scale, orientation: orientation) { photo in
      DispatchQueue.main.async { handler(photo) }
    }
  }
}
