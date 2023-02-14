//
//  MetalTexturePool.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import AVFoundation

@available(iOS 11.0, *)
final class MetalTexturePool {

  enum Error: Swift.Error {

    case metalTextureCacheAllocation(errorCode: CVReturn)

    case metalTextureAllocation(errorCode: CVReturn)

    case noMTLTexture
  }

  let device: MTLDevice

  let pixelBufferPool: PixelBufferPool

  let attributes: MetalTexture.Attributes

  let metalTextureCache: CVMetalTextureCache

  init(
    device: MTLDevice,
    pixelBufferPool: PixelBufferPool,
    attributes: MetalTexture.Attributes
  ) throws {
    self.device = device
    self.pixelBufferPool = pixelBufferPool
    self.attributes = attributes

    var metalTextureCache: CVMetalTextureCache?
    let errorCode = CVMetalTextureCacheCreate(
      nil,
      [kCVMetalTextureUsage: MTLTextureUsage.shaderWrite] as CFDictionary,
      device,
      nil,
      &metalTextureCache
    )

    switch (errorCode, metalTextureCache) {
    case (kCVReturnSuccess, .some(let metalTextureCache)):
      self.metalTextureCache = metalTextureCache
    default:
      throw Error.metalTextureCacheAllocation(errorCode: errorCode)
    }
  }

  func getMetalTexture(
    propagatedAttachments: [String: Any]? = nil,
    nonPropagatedAttachments: [String: Any]? = nil
  ) throws -> MetalTexture {
    let pixelBuffer = try pixelBufferPool.getPixelBuffer(
      propagatedAttachments: propagatedAttachments,
      nonPropagatedAttachments: nonPropagatedAttachments
    )

    var cvMetalTexture: CVMetalTexture?
    let errorCode = CVMetalTextureCacheCreateTextureFromImage(
      nil,
      metalTextureCache,
      pixelBuffer.cvPxelBuffer,
      nil,
      attributes.pixelFormat,
      attributes.width,
      attributes.height,
      attributes.planeIndex,
      &cvMetalTexture
    )

    switch (errorCode, cvMetalTexture) {
    case (kCVReturnSuccess, .some(let cvMetalTexture)):
      guard let mtlTexture = CVMetalTextureGetTexture(cvMetalTexture) else {
        throw Error.noMTLTexture
      }
      return MetalTexture(
        attributes: attributes,
        pixelBuffer: pixelBuffer,
        cvMetalTexture: cvMetalTexture,
        mtlTexture: mtlTexture
      )
    default:
      throw Error.metalTextureAllocation(errorCode: errorCode)
    }
  }
}
