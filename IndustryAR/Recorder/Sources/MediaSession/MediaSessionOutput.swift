//
//  MediaSessionOutput.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//


import Foundation
import AVFoundation

protocol MediaSessionOutput: AnyObject {

//  typealias Audio = AudioMediaSessionOutput
//
//  typealias Video = VideoMediaSessionOutput
}

protocol AudioMediaSessionOutput: MediaSessionOutput {

  func appendAudioSampleBuffer(_ sampleBuffer: CMSampleBuffer)
}

protocol VideoMediaSessionOutput: MediaSessionOutput {

  func appendVideoSampleBuffer(_ sampleBuffer: CMSampleBuffer)

  func appendVideoPixelBuffer(_ pixelBuffer: CVPixelBuffer, at time: CMTime)
}
