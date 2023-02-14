//
//  CAMetalLayer+RecordableLayer.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import UIKit
import AVFoundation

private var lastTextureKey: UInt8 = 0

#if !targetEnvironment(simulator)

extension CAMetalLayer {

  var lastTextureStorage: AssociatedStorage<MTLTexture> {
    AssociatedStorage(object: self, key: &lastTextureKey, policy: .OBJC_ASSOCIATION_RETAIN)
  }
}

extension CAMetalLayer: RecordableLayer {

  static let swizzleNextDrawableImplementation: Void = {
      let aClass: AnyClass = CAMetalLayer.self

      guard let originalMethod = class_getInstanceMethod(aClass, #selector(nextDrawable)),
            let swizzledMethod = class_getInstanceMethod(aClass, #selector(swizzled_nextDrawable))
      else { return }

      method_exchangeImplementations(originalMethod, swizzledMethod)
  }()

  static func swizzle() {
    _ = swizzleNextDrawableImplementation
  }

  public var lastTexture: MTLTexture? {
    get { lastTextureStorage.get() }
    set { lastTextureStorage.set(newValue) }
  }

  @objc dynamic func swizzled_nextDrawable() -> CAMetalDrawable? {
    let nextDrawable = swizzled_nextDrawable()
    lastTexture = nextDrawable?.texture
    return nextDrawable
  }
}

#else // IF targetEnvironment(simulator)

@available(iOS 13.0, *)
extension CAMetalLayer {

  var lastTextureStorage: AssociatedStorage<MTLTexture> {
    AssociatedStorage(object: self, key: &lastTextureKey, policy: .OBJC_ASSOCIATION_RETAIN)
  }
}

@available(iOS 13.0, *)
extension CAMetalLayer: RecordableLayer {

  static let swizzleNextDrawableImplementation: Void = {
      let aClass: AnyClass = CAMetalLayer.self

      guard let originalMethod = class_getInstanceMethod(aClass, #selector(nextDrawable)),
            let swizzledMethod = class_getInstanceMethod(aClass, #selector(swizzled_nextDrawable))
      else { return }

      method_exchangeImplementations(originalMethod, swizzledMethod)
  }()

  static func swizzle() {
    _ = swizzleNextDrawableImplementation
  }

  public var lastTexture: MTLTexture? {
    get { lastTextureStorage.get() }
    set { lastTextureStorage.set(newValue) }
  }

  @objc dynamic func swizzled_nextDrawable() -> CAMetalDrawable? {
    let nextDrawable = swizzled_nextDrawable()
    lastTexture = nextDrawable?.texture
    return nextDrawable
  }
}

#endif // END !targetEnvironment(simulator)
