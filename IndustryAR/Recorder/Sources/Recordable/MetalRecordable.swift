//
//  MetalRecordable.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation

public protocol MetalRecordable {

  var recordableLayer: RecordableLayer? { get }
}
