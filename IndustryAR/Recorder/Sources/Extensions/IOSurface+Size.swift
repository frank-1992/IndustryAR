//
//  IOSurface+Size.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import UIKit

@available(iOS 11.0, *)
extension IOSurface {

  var size: CGSize { CGSize(width: width, height: height) }
}
