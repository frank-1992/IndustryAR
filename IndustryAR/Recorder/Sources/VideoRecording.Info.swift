//
//  VideoRecording.Info.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import AVFoundation

@available(iOS 11.0, *)
public extension VideoRecording {

  struct Info {

    public var url: URL

    public var fileType: AVFileType

    public var duration: TimeInterval

    init(_ videoRecording: VideoRecording) {
      url = videoRecording.url
      fileType = videoRecording.fileType
      duration = videoRecording.duration
    }
  }
}
