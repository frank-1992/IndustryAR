//
//  DashLine.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/11/23.
//

import UIKit
import SceneKit

class DashLine: SCNNode {
 
}


extension SCNVector3 {
    
    static func + (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }

    static func - (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }
    
    static func / (vector: SCNVector3, scalar: Float) -> SCNVector3 {
        return SCNVector3(vector.x / scalar, vector.y / scalar, vector.z / scalar)
    }
    
    var length: Float {
        return sqrt(x * x + y * y + z * z)
    }
}
