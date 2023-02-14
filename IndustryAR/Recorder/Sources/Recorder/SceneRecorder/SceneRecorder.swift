//
//  SceneRecorder.swift
//  SceneRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import SceneKit
import ARKit

@available(iOS 11.0, *)
public final class SceneRecorder: BaseRecorder, Renderable, SCNSceneRendererDelegate {

  let videoInput: VideoInput

  init(videoInput: VideoInput, queue: DispatchQueue) {
    self.videoInput = videoInput
    super.init(
      queue: queue,
      mediaSession: MediaSession(queue: queue, videoInput: videoInput)
    )
  }

  public convenience init<T: MetalRecordable>(
    _ recordable: T,
    timeScale: CMTimeScale = 600
  ) throws {
    let queue = DispatchQueue(
      label: "SCNRecorder.Processing.DispatchQueue",
      qos: .userInitiated
    )
    try self.init(
      videoInput: VideoInput(
        recordable: recordable,
        timeScale: timeScale,
        queue: queue
      ),
      queue: queue
    )
  }

  public func render(atTime time: TimeInterval) {
    do {
      try videoInput.render(
        atTime: time,
        error: { [weak self] in self?.error = $0 }
      )
    }
    catch {
      self.error = error
    }
  }

  public func render(atTime time: TimeInterval, using commandQueue: MTLCommandQueue) {
    do {
      try videoInput.render(
        atTime: time,
        using: commandQueue,
        error: { [weak self] in self?.error = $0 }
      )
    }
    catch {
      self.error = error
    }
  }

  public func renderer(
    _ renderer: SCNSceneRenderer,
    didRenderScene scene: SCNScene,
    atTime time: TimeInterval
  ) {
    guard let commandQueue = renderer.commandQueue else { return }
    render(atTime: time, using: commandQueue)
  }
}
