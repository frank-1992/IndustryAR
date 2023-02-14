//
//  ImageOutput.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import AVFoundation
import UIKit
import VideoToolbox
import CoreVideo

enum ImageOutput {

  enum Error: Swift.Error {

    case createCGImageFromCVPixelBufferFailed(_ status: OSStatus)
  }

  static func takeUIImage(
    scale: CGFloat,
    orientation: UIImage.Orientation,
    handler: @escaping (Result<UIImage, Swift.Error>) -> Void
  ) -> (Result<CVPixelBuffer, Swift.Error>) -> Void {
    takeCGImage { result in
      handler(
        result.map {
          UIImage(cgImage: $0, scale: scale, orientation: orientation)
        }
      )
    }
  }

  static func takeCIImage(
    handler: @escaping (Result<CIImage, Swift.Error>) -> Void
  ) -> (Result<CVPixelBuffer, Swift.Error>) -> Void {
    takeCGImage { result in
      handler(
        result.map {
          CIImage(cgImage: $0)
        }
      )
    }
  }

  static func takeCGImage(
    handler: @escaping (Result<CGImage, Swift.Error>) -> Void
  ) -> (Result<CVPixelBuffer, Swift.Error>) -> Void {
    {
      handler($0.flatMap { pixelBuffer in
        var cgImage: CGImage?
        let status = VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)

        guard let image = cgImage else {
          return .failure(Error.createCGImageFromCVPixelBufferFailed(status))
        }
        return .success(image)
      })
    }
  }

  static func takePixelBuffer(
    handler: @escaping (Result<CVPixelBuffer, Swift.Error>) -> Void
  ) -> (CVPixelBuffer, CMTime) -> Void {
    { (pixelBuffer, _) in
      handler(.success(pixelBuffer))
    }
  }
}
