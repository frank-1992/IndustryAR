//
//  SelfSceneRecordable.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import UIKit
import SceneKit

private var sceneRecorderKey: UInt8 = 0

@available(iOS 11.0, *)
public protocol SelfSceneRecordable: SelfRecordable {

  var sceneRecorder: SceneRecorder? { get set }
}

@available(iOS 11.0, *)
extension SelfSceneRecordable {

  public var recorder: (BaseRecorder & Renderable)? { sceneRecorder }
}

@available(iOS 11.0, *)
extension SelfSceneRecordable {

  var sceneRecorderStorage: AssociatedStorage<SceneRecorder> {
    AssociatedStorage(object: self, key: &sceneRecorderKey, policy: .OBJC_ASSOCIATION_RETAIN)
  }

  public var sceneRecorder: SceneRecorder? {
    get { sceneRecorderStorage.get() }
    set { sceneRecorderStorage.set(newValue) }
  }
}

@available(iOS 11.0, *)
extension SelfSceneRecordable where Self: MetalRecordable {

  public func injectRecorder() {
    assert(sceneRecorder == nil)

    do { sceneRecorder = try SceneRecorder(self) }
    catch { assertionFailure("\(error)") }
  }
}
