//
//  VideoSettings.FileType.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//


import Foundation
import AVFoundation

@available(iOS 11.0, *)
public extension VideoSettings {

  enum FileType: CaseIterable {

    /// A UTI for the QuickTime movie file format.
    ///
    /// The value of this UTI is @"com.apple.quicktime-movie".
    ///
    /// Files are identified with the .mov and .qt extensions.
    case mov

    /// A UTI for the MPEG-4 file format.
    ///
    /// The value of this UTI is @"public.mpeg-4".
    ///
    /// Files are identified with the .mp4 extension.
    case mp4

    /// A UTI for video container format very similar to the MP4 format.
    ///
    /// The value of this UTI is @"com.apple.m4v-video".
    ///
    /// Files are identified with the .m4v extension.
    case m4v

    /// A UTI for the 3GPP file format.
    ///
    /// The value of this UTI is @"public.3gpp".
    ///
    /// Files are identified with the .3gp, .3gpp, and .sdv extensions.
    case mobile3GPP
  }
}
@available(iOS 11.0, *)
extension VideoSettings.FileType {

  var avFileType: AVFileType {
    switch self {
    case .mov: return .mov
    case .mp4: return .mp4
    case .m4v: return .m4v
    case .mobile3GPP: return .mobile3GPP
    }
  }

  var fileExtension: String {
    switch self {
    case .mov: return "mov"
    case .mp4: return "mp4"
    case .m4v: return "m4v"
    case .mobile3GPP: return "3gp"
    }
  }
}
