//
//  CleanRecorder.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import ARKit

@available(iOS 11.0, *)
public final class CleanRecorder<T: CleanRecordable>: BaseRecorder,
  Renderable, SCNSceneRendererDelegate {

  let videoInput: VideoInput<T>

  init(_ cleanRecordable: T, timeScale: CMTimeScale = 600) {
    let queue = DispatchQueue(label: "SCNRecorder.Processing.DispatchQueue", qos: .userInitiated)

    self.videoInput = VideoInput(
      cleanRecordable: cleanRecordable,
      timeScale: timeScale,
      queue: queue
    )

    super.init(queue: queue, mediaSession: MediaSession(queue: queue, videoInput: videoInput))
  }

  func _render(atTime time: TimeInterval) {
    do { try videoInput.render(atTime: time) }
    catch { self.error = error }
  }

  public func render(atTime time: TimeInterval) {
    assert(T.self != SCNView.self, "\(#function) must not be called for \(T.self)")
    _render(atTime: time)
  }

  public func renderer(
    _ renderer: SCNSceneRenderer,
    didRenderScene scene: SCNScene,
    atTime time: TimeInterval
  ) { _render(atTime: time) }
}
