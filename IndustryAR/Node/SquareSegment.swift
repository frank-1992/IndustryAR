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
    static let thickness: CGFloat = 0.018

    /// Length of the focus square lines in m.
    static let length: CGFloat = 1  // segment length

    let plane: SCNPlane

    init(name: String) {
        plane = SCNPlane(width: Segment.thickness, height: Segment.length)
        super.init()
        self.name = name
        
        let material = plane.firstMaterial!
        material.diffuse.contents = Square.primaryColor
        material.isDoubleSided = true
        material.ambient.contents = UIColor.black
        material.lightingModel = .constant
        material.emission.contents = Square.primaryColor
        geometry = plane
        
        material.writesToDepthBuffer = false
        material.readsFromDepthBuffer = false
        renderingOrder = 100
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
}
