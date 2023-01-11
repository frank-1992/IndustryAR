//
//  Circle.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/11/23.
//

import UIKit
import SceneKit

class Circle: SCNNode {

    static let size: Float = 0.01
    
    // Thickness of the focus square lines in meters.
    static let thickness: CGFloat = 0.018
    
    static let ringRadius: CGFloat = 1.0
    
    static let primaryColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        
    private let positioningNode = SCNNode()
    
    override init() {
        super.init()
        
        let circleNode = SCNNode(geometry: SCNTorus(ringRadius: Circle.ringRadius, pipeRadius: Circle.thickness))
        circleNode.geometry?.firstMaterial?.diffuse.contents = Circle.primaryColor
        
        positioningNode.eulerAngles.x = .pi / 2 // Horizontal
        positioningNode.simdScale = [1.0, 1.0, 1.0] * Circle.size
        positioningNode.addChildNode(circleNode)
        
        addChildNode(positioningNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
