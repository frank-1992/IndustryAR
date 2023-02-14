//
//  SCNView+MetalRecordable.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import SceneKit
import ARKit

extension SCNView: MetalRecordable {

  public var recordableLayer: RecordableLayer? { layer as? RecordableLayer }
}
