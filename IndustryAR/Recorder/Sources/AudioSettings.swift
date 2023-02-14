//
//  AudioSettings.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import AVFoundation

public struct AudioSettings {

  static let defaultSampleRate = 44100.0

  static let defaultNumberOfChannels = 1

  public var format = kAudioFormatMPEG4AAC

  public var sampleRate = defaultSampleRate

  public var numberOfChannels = defaultNumberOfChannels
}

extension AudioSettings {

  init(audioFormat: AVAudioFormat) {
    sampleRate = audioFormat.sampleRate
    numberOfChannels = Int(audioFormat.channelCount)
  }

  var outputSettings: [String: Any] {
    [
      AVFormatIDKey: format,
      AVSampleRateKey: sampleRate,
      AVNumberOfChannelsKey: numberOfChannels
    ]
  }
}
