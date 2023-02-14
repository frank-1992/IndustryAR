//
//  MediaSessionInput.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//


import Foundation
import AVFoundation
import UIKit


public typealias MediaSessionInput_SampleBufferAudio = AudioMediaSessionInput & SampleBufferInput
public typealias MediaSessionInput_SampleBufferVideo = VideoMediaSessionInput & SampleBufferInput
public typealias MediaSessionInput_PixelBufferVideo = VideoMediaSessionInput & BufferInput


public
protocol MediaSessionInput {

//  typealias Audio = AudioMediaSessionInput
//
//  typealias Video = VideoMediaSessionInput

//  typealias SampleBufferAudio = AudioMediaSessionInput & SampleBufferInput
//
//  typealias SampleBufferVideo = VideoMediaSessionInput & SampleBufferInput
//
//  typealias PixelBufferVideo = VideoMediaSessionInput & BufferInput

  func start()

  func stop()
}

public
protocol AudioMediaSessionInput: MediaSessionInput {

  func recommendedAudioSettingsForAssetWriter(
    writingTo outputFileType: AVFileType
  ) -> [String: Any]
}

public
protocol VideoMediaSessionInput: MediaSessionInput {

  var size: CGSize { get }

  var videoColorProperties: [String: String]? { get }

  var videoTransform: CGAffineTransform { get }

  var imageOrientation: UIImage.Orientation { get }
}

public
protocol SampleBufferInput: AnyObject {

  var output: ((CMSampleBuffer) -> Void)? { get set }
}

public
protocol BufferInput: AnyObject {

  var output: ((CVBuffer, CMTime) -> Void)? { get set }
}
