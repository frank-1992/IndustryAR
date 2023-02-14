//
//  TimeScalable.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import AVFoundation

protocol TimeScalable {

  var timeScale: CMTimeScale { get }
}

extension TimeScalable {

  func timeFromSeconds(_ seconds: TimeInterval) -> CMTime {
    CMTime(seconds: seconds, preferredTimescale: timeScale)
  }
}
