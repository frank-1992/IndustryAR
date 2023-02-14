//
//  RecordableLayer.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import UIKit
import AVFoundation

public protocol RecordableLayer: AnyObject {

  var lastTexture: MTLTexture? { get }

  var device: MTLDevice? { get }

  var pixelFormat: MTLPixelFormat { get }

  var drawableSize: CGSize { get }

  var colorspace: CGColorSpace? { get }

  var framebufferOnly: Bool { get }

  var interfaceOrientation: UIInterfaceOrientation { get }

  func prepareForRecording()
}

public extension RecordableLayer {

  func prepareForRecording() { }
}

#if !targetEnvironment(simulator)

public extension RecordableLayer where Self: CAMetalLayer {

  func prepareForRecording() { Self.swizzle() }
}

#else

@available(iOS 13.0, *)
public extension RecordableLayer where Self: CAMetalLayer {

  func prepareForRecording() { Self.swizzle() }
}

#endif
