//
//  PixelBuffer.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import AVFoundation

@available(iOS 11.0, *)
final class PixelBuffer: CustomStringConvertible {

  struct Attributes: Hashable {

    var width: Int

    var height: Int

    var pixelFormat: OSType

    var cfDictionary: CFDictionary {
      [
        kCVPixelBufferWidthKey: width,
        kCVPixelBufferHeightKey: height,
        kCVPixelBufferPixelFormatTypeKey: pixelFormat,
        kCVPixelBufferIOSurfacePropertiesKey: [:],
        kCVPixelBufferMetalCompatibilityKey: true
      ] as CFDictionary
    }

    init(
      width: Int,
      height: Int,
      pixelFormat: OSType
    ) {
      self.width = width
      self.height = height
      self.pixelFormat = pixelFormat
    }

    init(_ attributes: MetalTexture.Attributes) {
      width = attributes.width
      height = attributes.height
      pixelFormat = attributes.pixelFormat.pixelFormatType
    }
  }

  enum Error: Swift.Error {
    case allocation(errorCode: CVReturn)
    case lockBaseAddress(errorCode: CVReturn)
    case unlockBaseAddress(errorCode: CVReturn)
  }

  let cvPxelBuffer: CVPixelBuffer

  var baseAddress: UnsafeMutableRawPointer? { CVPixelBufferGetBaseAddress(cvPxelBuffer) }

  var bytesPerRow: Int { CVPixelBufferGetBytesPerRow(cvPxelBuffer) }

  var width: Int { CVPixelBufferGetWidth(cvPxelBuffer) }

  var height: Int { CVPixelBufferGetHeight(cvPxelBuffer) }

  var bytesCount: Int { bytesPerRow * height }

  var pixelFormat: OSType { CVPixelBufferGetPixelFormatType(cvPxelBuffer) }

  var propagatedAttachments: [String: Any]? {
    get { CVBufferGetAttachments(cvPxelBuffer, .shouldPropagate) as? [String: Any] }
    set {
      guard let attachments = newValue else { return }
      CVBufferSetAttachments(cvPxelBuffer, attachments as CFDictionary, .shouldPropagate)
    }
  }

  var nonPropagatedAttachments: [String: Any]? {
    get { CVBufferGetAttachments(cvPxelBuffer, .shouldNotPropagate) as? [String: Any] }
    set {
      guard let attachments = newValue else { return }
      CVBufferSetAttachments(cvPxelBuffer, attachments as CFDictionary, .shouldNotPropagate)
    }
  }

  var description: String { "\(cvPxelBuffer)" }

  init(_ cvPxelBuffer: CVPixelBuffer) { self.cvPxelBuffer = cvPxelBuffer }

  convenience init(_ surface: IOSurface) throws {
    var unmanagedPixelBuffer: Unmanaged<CVPixelBuffer>?

    let errorCode = CVPixelBufferCreateWithIOSurface(
      nil,
      surface,
      nil,
      &unmanagedPixelBuffer
    )

    guard errorCode == kCVReturnSuccess,
          let pixelBuffer = unmanagedPixelBuffer?.takeRetainedValue()
    else { throw Error.allocation(errorCode: errorCode) }

    self.init(pixelBuffer)
  }

  @discardableResult
  func locked(
    readOnly: Bool = false,
    handler: (PixelBuffer) throws -> Void
  ) throws -> PixelBuffer {
    try lock(readOnly: readOnly)
    defer { try? unlock(readOnly: readOnly) }
    try handler(self)
    return self
  }

  func lock(readOnly: Bool = false) throws {
    let errorCode = CVPixelBufferLockBaseAddress(cvPxelBuffer, readOnly ? [.readOnly] : [])
    guard errorCode == kCVReturnSuccess else { throw Error.lockBaseAddress(errorCode: errorCode) }
  }

  func unlock(readOnly: Bool = false) throws {
    let errorCode = CVPixelBufferUnlockBaseAddress(cvPxelBuffer, readOnly ? [.readOnly] : [])
    guard errorCode == kCVReturnSuccess else { throw Error.unlockBaseAddress(errorCode: errorCode) }
  }

  func copyFrom(_ pixelBuffer: CVPixelBuffer) throws { try copyFrom(PixelBuffer(pixelBuffer)) }

  func copyFrom(_ pixelBuffer: PixelBuffer) throws {
    try pixelBuffer.locked { (pixelBuffer) in
      try locked { (this) in
        memcpy(this.baseAddress, pixelBuffer.baseAddress, this.bytesCount)
        this.propagatedAttachments = pixelBuffer.propagatedAttachments
      }
    }
  }
}
