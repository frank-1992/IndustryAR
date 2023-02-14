//
//  VideoSettings.Codec.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//


import Foundation
import AVFoundation

@available(iOS 11.0, *)
public extension VideoSettings {

  enum Codec {

    public static func hevc(
      averageBitRate: Int? = nil,
      maxKeyFrameInterval: Int? = nil,
      maxKeyFrameIntervalDuration: TimeInterval? = nil,
      allowFrameReordering: Bool? = nil,
      expectedSourceFrameRate: Int? = nil,
      averageNonDroppableFrameRate: Int? = nil,
      profileLevel: HEVCCompressionProperties.ProfileLevel? = nil
    ) -> Codec {
      .hevc(.init(
        averageBitRate: averageBitRate,
        maxKeyFrameInterval: maxKeyFrameInterval,
        maxKeyFrameIntervalDuration: maxKeyFrameIntervalDuration,
        allowFrameReordering: allowFrameReordering,
        expectedSourceFrameRate: expectedSourceFrameRate,
        averageNonDroppableFrameRate: averageNonDroppableFrameRate,
        profileLevel: profileLevel
      ))
    }

    case hevc(_ compressionProperties: HEVCCompressionProperties)

    @available(iOS 13.0, *)
    public static func hevcWithAlpha(
      averageBitRate: Int? = nil,
      maxKeyFrameInterval: Int? = nil,
      maxKeyFrameIntervalDuration: TimeInterval? = nil,
      allowFrameReordering: Bool? = nil,
      expectedSourceFrameRate: Int? = nil,
      averageNonDroppableFrameRate: Int? = nil,
      profileLevel: HEVCCompressionProperties.ProfileLevel? = nil
    ) -> Codec {
      .hevcWithAlpha(.init(
        averageBitRate: averageBitRate,
        maxKeyFrameInterval: maxKeyFrameInterval,
        maxKeyFrameIntervalDuration: maxKeyFrameIntervalDuration,
        allowFrameReordering: allowFrameReordering,
        expectedSourceFrameRate: expectedSourceFrameRate,
        averageNonDroppableFrameRate: averageNonDroppableFrameRate,
        profileLevel: profileLevel
      ))
    }

    case hevcWithAlpha(_ compressionProperties: HEVCCompressionProperties)

    public static func h264(
      averageBitRate: Int? = nil,
      maxKeyFrameInterval: Int? = nil,
      maxKeyFrameIntervalDuration: TimeInterval? = nil,
      allowFrameReordering: Bool? = nil,
      expectedSourceFrameRate: Int? = nil,
      averageNonDroppableFrameRate: Int? = nil,
      profileLevel: H264CompressionProperties.ProfileLevel? = nil,
      entropyMode: H264CompressionProperties.EntropyMode? = nil
    ) -> Codec {
      .h264(.init(
        averageBitRate: averageBitRate,
        maxKeyFrameInterval: maxKeyFrameInterval,
        maxKeyFrameIntervalDuration: maxKeyFrameIntervalDuration,
        allowFrameReordering: allowFrameReordering,
        expectedSourceFrameRate: expectedSourceFrameRate,
        averageNonDroppableFrameRate: averageNonDroppableFrameRate,
        profileLevel: profileLevel,
        entropyMode: entropyMode
      ))
    }

    case h264(_ compressionProperties: H264CompressionProperties)

    public static func jpeg(
      averageBitRate: Int? = nil,
      maxKeyFrameInterval: Int? = nil,
      maxKeyFrameIntervalDuration: TimeInterval? = nil,
      allowFrameReordering: Bool? = nil,
      expectedSourceFrameRate: Int? = nil,
      averageNonDroppableFrameRate: Int? = nil
    ) -> Codec {
      .jpeg(.init(
        averageBitRate: averageBitRate,
        maxKeyFrameInterval: maxKeyFrameInterval,
        maxKeyFrameIntervalDuration: maxKeyFrameIntervalDuration,
        allowFrameReordering: allowFrameReordering,
        expectedSourceFrameRate: expectedSourceFrameRate,
        averageNonDroppableFrameRate: averageNonDroppableFrameRate
      ))
    }

    case jpeg(_ compressionProperties: JPEGCompressionProperties)

    var _compressionProperties: CompressionProperties {
      switch self {
      case .hevc(let compressionProperties as CompressionProperties),
           .hevcWithAlpha(let compressionProperties as CompressionProperties),
           .h264(let compressionProperties as CompressionProperties),
           .jpeg(let compressionProperties as CompressionProperties):
        return compressionProperties
      }
    }

    public var compressionProperties: [String: Any]? {
      _compressionProperties.settings
    }
  }
}

@available(iOS 11.0, *)
public extension VideoSettings.Codec {

  var avCodec: AVVideoCodecType {
    switch self {
    case .hevc:
      return .hevc
    case .hevcWithAlpha:
      if #available(iOS 13.0, *) { return .hevcWithAlpha }
      else { return .hevc }
    case .h264:
      return .h264
    case .jpeg:
      return .jpeg
    }
  }
}
