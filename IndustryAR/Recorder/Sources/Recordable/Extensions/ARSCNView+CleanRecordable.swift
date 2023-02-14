//
//  ARSCNView+CleanRecordable.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import ARKit

@available(iOS 11.0, *)
extension ARSCNView: CleanRecordable {

  public var cleanPixelBuffer: CVPixelBuffer? { session.currentFrame?.capturedImage }
}
