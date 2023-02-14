//
//  PixelBufferPool.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import AVFoundation

@available(iOS 11.0, *)
final class PixelBufferPool {

  enum Error: Swift.Error {
    case pixelBufferPoolAllocation(errorCode: CVReturn)

    case allocationTresholdExceeded
    case pixelBufferAllocation(errorCode: CVReturn)
  }

  let pixelBufferPool: CVPixelBufferPool

  var allocationTreshold: UInt = 0

  init(_ pixelBufferPool: CVPixelBufferPool) { self.pixelBufferPool = pixelBufferPool }

  convenience init(attributes: PixelBuffer.Attributes) throws {
    var unmanagedPixelBufferPool: CVPixelBufferPool?
    let errorCode = CVPixelBufferPoolCreate(
      nil,
      nil,
      attributes.cfDictionary,
      &unmanagedPixelBufferPool
    )

    guard errorCode == kCVReturnSuccess,
          let pixelBufferPool = unmanagedPixelBufferPool
    else { throw Error.pixelBufferPoolAllocation(errorCode: errorCode) }

    self.init(pixelBufferPool)
  }

  func getPixelBuffer(
    propagatedAttachments: [String: Any]? = nil,
    nonPropagatedAttachments: [String: Any]? = nil
  ) throws -> PixelBuffer {
    var unmanagedPixelBuffer: CVPixelBuffer?

    let errorCode = CVPixelBufferPoolCreatePixelBufferWithAuxAttributes(
      nil,
      pixelBufferPool,
      allocationTreshold == 0
        ? nil
        : [kCVPixelBufferPoolAllocationThresholdKey: allocationTreshold] as CFDictionary,
      &unmanagedPixelBuffer
    )

    switch (errorCode, unmanagedPixelBuffer) {
    case (kCVReturnSuccess, .some(let cvPixelBuffer)):
      let pixelBuffer = PixelBuffer(cvPixelBuffer)
      pixelBuffer.propagatedAttachments = propagatedAttachments
      pixelBuffer.nonPropagatedAttachments = nonPropagatedAttachments
      return pixelBuffer
    case (kCVReturnWouldExceedAllocationThreshold, _):
      throw Error.allocationTresholdExceeded
    default:
      throw Error.pixelBufferAllocation(errorCode: errorCode)
    }
  }
}
