//
//  MetalTexture.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//


import Foundation
import AVFoundation
import Metal

@available(iOS 11.0, *)
final class MetalTexture {

  struct Attributes: Hashable {

    var width: Int

    var height: Int

    var pixelFormat: MTLPixelFormat

    var planeIndex: Int = 0
  }

  let attributes: Attributes

  let pixelBuffer: PixelBuffer

  let cvMetalTexture: CVMetalTexture

  let mtlTexture: MTLTexture

  init(
    attributes: Attributes,
    pixelBuffer: PixelBuffer,
    cvMetalTexture: CVMetalTexture,
    mtlTexture: MTLTexture
  ) {
    self.attributes = attributes
    self.pixelBuffer = pixelBuffer
    self.cvMetalTexture = cvMetalTexture
    self.mtlTexture = mtlTexture
  }
}
