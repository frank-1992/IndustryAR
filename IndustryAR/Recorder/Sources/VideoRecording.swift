//
//  VideoRecording.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//


import Foundation
import AVFoundation

@available(iOS 11.0, *)
public final class VideoRecording {

  @Observable public internal(set) var duration: TimeInterval

  @Observable public internal(set) var state: State

  public var url: URL { videoOutput.url }

  public var fileType: AVFileType { videoOutput.fileType }

  let videoOutput: VideoOutput

  init(videoOutput: VideoOutput) {
    self.state = videoOutput.state
    self.duration = videoOutput.duration
    self.videoOutput = videoOutput
  }

  public func resume() { videoOutput.resume() }

  public func pause() { videoOutput.pause() }

  public func finish(completionHandler handler: @escaping (_ info: Info) -> Void) {
    videoOutput.finish { handler(Info(self)) }
  }

  func cancel() { videoOutput.cancel() }
}
