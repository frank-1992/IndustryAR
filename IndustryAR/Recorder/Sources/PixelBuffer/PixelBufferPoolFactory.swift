//
//  PixelBufferPoolFactory.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import AVFoundation

@available(iOS 11.0, *)
final class PixelBufferPoolFactory {

  private static let weaklySharedAllocationTreshold: UInt = 10

  private static weak var shared: PixelBufferPoolFactory?

  static func getWeaklyShared() -> PixelBufferPoolFactory {
    if let shared = shared { return shared }

    let pixelBufferPoolFactory = PixelBufferPoolFactory(
      allocationTreshold: weaklySharedAllocationTreshold
    )
    shared = pixelBufferPoolFactory
    return pixelBufferPoolFactory
  }

  var pixelBufferPools = [PixelBuffer.Attributes: PixelBufferPool]()

  let allocationTreshold: UInt

  init(allocationTreshold: UInt) { self.allocationTreshold = allocationTreshold }

  func getPixelBufferPool(for pixelBuffer: CVPixelBuffer) throws -> PixelBufferPool {
    try getPixelBufferPool(for: PixelBuffer(pixelBuffer))
  }

  func getPixelBufferPool(for pixelBuffer: PixelBuffer) throws -> PixelBufferPool {
    try getPixelBufferPool(
      width: pixelBuffer.width,
      height: pixelBuffer.height,
      pixelFormat: pixelBuffer.pixelFormat
    )
  }

  func getPixelBufferPool(
    width: Int,
    height: Int,
    pixelFormat: OSType
  ) throws -> PixelBufferPool {
    try getPixelBufferPool(
      attributes: PixelBuffer.Attributes(
        width: width,
        height: height,
        pixelFormat: pixelFormat
      )
    )
  }

  func getPixelBufferPool(attributes: PixelBuffer.Attributes) throws -> PixelBufferPool {
    if let pixelBufferPool = pixelBufferPools[attributes] { return pixelBufferPool }

    let pixelBufferPool = try PixelBufferPool(attributes: attributes)
    pixelBufferPool.allocationTreshold = allocationTreshold
    pixelBufferPools[attributes] = pixelBufferPool
    return pixelBufferPool
  }
}
