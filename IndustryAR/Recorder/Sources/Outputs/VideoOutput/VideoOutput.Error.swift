//
//  VideoOutput.Error.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation

@available(iOS 11.0, *)
extension VideoOutput {

  enum Error: Swift.Error {

    case cantAddVideoAssetWriterInput

    case cantAddAudioAssterWriterInput(audioSettings: [String: Any])

    case cantStartWriting

    case unknown
  }
}
