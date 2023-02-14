//
//  MetalTexturePoolFactory.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import Metal

@available(iOS 11.0, *)
final class MetalTexturePoolFactory {

  private static weak var shared: MetalTexturePoolFactory?

  static func getWeaklyShared(
    device: MTLDevice,
    pixelBufferPoolFactory: PixelBufferPoolFactory = .getWeaklyShared()
  ) -> MetalTexturePoolFactory {
    if let shared = shared { return shared }

    let metalTexturePoolFactory = MetalTexturePoolFactory(
      device: device,
      pixelBufferPoolFactory: pixelBufferPoolFactory
    )
    shared = metalTexturePoolFactory
    return metalTexturePoolFactory
  }

  let device: MTLDevice

  let pixelBufferPoolFactory: PixelBufferPoolFactory

  var metalTexturePools = [MetalTexture.Attributes: MetalTexturePool]()

  init(
    device: MTLDevice,
    pixelBufferPoolFactory: PixelBufferPoolFactory
  ) {
    self.device = device
    self.pixelBufferPoolFactory = pixelBufferPoolFactory
  }

  func getMetalTexturePool(
    width: Int,
    height: Int,
    pixelFormat: MTLPixelFormat
  ) throws -> MetalTexturePool {
    try getMetalTexturePool(
      MetalTexture.Attributes(
        width: width,
        height: height,
        pixelFormat: pixelFormat
      )
    )
  }

  func getMetalTexturePool(_ attributes: MetalTexture.Attributes) throws -> MetalTexturePool {
    if let metalTexturePool = metalTexturePools[attributes] { return metalTexturePool }

    let pixelBufferAttributes = PixelBuffer.Attributes(attributes)
    let pixelBufferPool = try pixelBufferPoolFactory.getPixelBufferPool(
      attributes: pixelBufferAttributes
    )
    let metalTexturePool = try MetalTexturePool(
      device: device,
      pixelBufferPool: pixelBufferPool,
      attributes: attributes
    )
    metalTexturePools[attributes] = metalTexturePool
    return metalTexturePool
  }
}
