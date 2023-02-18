//
//  SceneModel.swift
//  IndustryAR
//
//  Created by  吴 熠 on 2023/2/18.
//

import UIKit
import SceneKit
import HandyJSON

class SceneModel: HandyJSON {
    
    var modelPositionX: Float = 0
    var modelPositionY: Float = 0
    var modelPositionZ: Float = 0
    var modelScale: Float = 1
    var modelOrientationX: Float = 0
    var modelOrientationY: Float = 0
    var modelOrientationZ: Float = 0
    var modelOrientationW: Float = 0
    
    required init() {}
}

