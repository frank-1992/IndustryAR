//
//  SCNView+SelfSceneRecordable.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import SceneKit

@available(iOS 11.0, *)
extension SCNView: SelfSceneRecordable {

  public func prepareForRecording() {
    Self.swizzle()

    recordableLayer?.prepareForRecording()

    guard sceneRecorder == nil else { return }
    injectRecorder()

    assert(sceneRecorder != nil)
    guard let recorder = sceneRecorder else { return }
    addDelegate(recorder)

    fixFirstLaunchFrameDrop()
  }
}
