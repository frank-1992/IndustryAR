//
//  CleanRecordable.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import ARKit

private var cleanKey: UInt8 = 0

public protocol CleanRecordable: AnyObject {

  var cleanPixelBuffer: CVPixelBuffer? { get }
}

@available(iOS 11.0, *)
public extension CleanRecordable {

  internal var cleanStorage: AssociatedStorage<Clean<Self>> {
    AssociatedStorage(object: self, key: &cleanKey, policy: .OBJC_ASSOCIATION_RETAIN)
  }

  internal var _clean: Clean<Self> {
    get {
      cleanStorage.get() ?? {
        let clean = Clean(cleanRecordable: self)
        _clean = clean
        return clean
      }()
    }
    set { cleanStorage.set(newValue) }
  }

  var clean: SelfRecordable { _clean }
}

@available(iOS 11.0, *)
final class Clean<T: CleanRecordable>: SelfRecordable {

  public var recorder: (BaseRecorder & Renderable)? { cleanRecorder }

  var cleanRecorder: CleanRecorder<T>?

  var videoRecording: VideoRecording?

  weak var cleanRecordable: T?

  init(cleanRecordable: T) {
    self.cleanRecordable = cleanRecordable
  }

  func injectRecorder() {
    assert(cleanRecorder == nil)
    assert(cleanRecordable != nil)

    cleanRecorder = cleanRecordable.map { CleanRecorder($0) }
  }

  func prepareForRecording() {
    (cleanRecordable as? SCNView)?.swizzle()
    guard cleanRecorder == nil else { return }

    injectRecorder()
    assert(cleanRecorder != nil)
    guard let cleanRecorder = cleanRecorder else { return }
    (cleanRecordable as? SCNView)?.addDelegate(cleanRecorder)

    fixFirstLaunchFrameDrop()
  }
}
