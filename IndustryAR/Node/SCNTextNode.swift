//
//  SCNTextNode.swift
//  IndustryAR
//
//  Created by  吴 熠 on 2023/3/2.
//

import UIKit
import SceneKit

class SCNTextNode: SCNNode {
        
    init(geometry: SCNGeometry) {
        super.init()
        self.geometry = geometry
        self.name = "text"
        self.scale = SCNVector3(x: ShapeSetting.textScale, y: ShapeSetting.textScale, z: ShapeSetting.textScale)
                
        self.pivot = SCNMatrix4MakeTranslation(
            self.boundingBox.min.x,
            self.boundingBox.min.y,
            self.boundingBox.min.z
        )
        
        let plane = SCNPlane(width: CGFloat(ShapeSetting.fontSize), height: CGFloat(ShapeSetting.fontSize))
        plane.firstMaterial?.diffuse.contents = UIImage(named: "shanchu-ar")
        plane.firstMaterial?.writesToDepthBuffer = false
        plane.firstMaterial?.readsFromDepthBuffer = false
        let planeNode = SCNNode(geometry: plane)
        planeNode.name = "plane_for_hit"
        planeNode.simdPosition = simd_float3(self.boundingBox.min.x, self.boundingBox.min.y, self.boundingBox.min.z + 0.01)
        planeNode.renderingOrder = 101
        addChildNode(planeNode)
        planeNode.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override class var supportsSecureCoding: Bool {
        return true
    }
}
