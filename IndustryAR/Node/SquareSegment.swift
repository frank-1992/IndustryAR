//
//  SquareSegment.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/10/23.
//

import UIKit
import SceneKit

class Segment: SCNNode {

    // MARK: - Configuration & Initialization

    /// Thickness of the focus square lines in m.
    static let thickness: CGFloat = 0.15

    let plane: SCNPlane

    init(name: String, lineLength: CGFloat) {
        plane = SCNPlane(width: CGFloat(ShapeSetting.lineThickness)/10000, height: lineLength)
        super.init()
        self.name = name
        
        let material = plane.firstMaterial!
        material.diffuse.contents = ShapeSetting.lineColor
        material.isDoubleSided = true
        material.ambient.contents = UIColor.black
        material.lightingModel = .constant
        material.emission.contents = ShapeSetting.lineColor
        geometry = plane
        
        material.writesToDepthBuffer = false
        material.readsFromDepthBuffer = false
        renderingOrder = 100
    }

    required init?(coder aDecoder: NSCoder) {
        plane = SCNPlane(width: CGFloat(ShapeSetting.lineThickness)/10000, height: CGFloat(ShapeSetting.lineLength/1000))
        super.init(coder: aDecoder)
    }
    
    override class var supportsSecureCoding: Bool {
        return true
    }
}
