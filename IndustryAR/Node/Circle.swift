//
//  Circle.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/11/23.
//

import UIKit
import SceneKit

class Circle: SCNNode {
            
    private let positioningNode = SCNNode()
    
    private var deleteFlag: SCNNode = SCNNode()
    
    override init() {
        super.init()
        create()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override class var supportsSecureCoding: Bool {
        return true
    }
    
    private func create() {
        let circleNode = SCNNode(geometry: SCNTorus(ringRadius:CGFloat(ShapeSetting.lineLength)/1000.0, pipeRadius: CGFloat(ShapeSetting.lineThickness)/15000))
        circleNode.geometry?.firstMaterial?.diffuse.contents = ShapeSetting.lineColor
        circleNode.geometry?.firstMaterial?.isDoubleSided = true
        circleNode.geometry?.firstMaterial?.ambient.contents = UIColor.black
        circleNode.geometry?.firstMaterial?.lightingModel = .constant
        circleNode.geometry?.firstMaterial?.emission.contents = ShapeSetting.lineColor
        
        positioningNode.eulerAngles.x = .pi / 2
        positioningNode.simdScale = [1.0, 1.0, 1.0]
        positioningNode.addChildNode(circleNode)
        
        circleNode.geometry?.firstMaterial?.writesToDepthBuffer = false
        circleNode.geometry?.firstMaterial?.readsFromDepthBuffer = false
        renderingOrder = 100
        addChildNode(positioningNode)
        
        let plane = SCNPlane(width: CGFloat(ShapeSetting.lineLength)/1000.0, height: CGFloat(ShapeSetting.lineLength)/1000.0)
        plane.firstMaterial?.diffuse.contents = UIImage(named: "shanchu-ar")
        plane.firstMaterial?.writesToDepthBuffer = false
        plane.firstMaterial?.readsFromDepthBuffer = false
        let planeNode = SCNNode(geometry: plane)
        planeNode.name = "plane_for_hit"
        planeNode.simdPosition = simd_float3(0, 0, 0.01)
        planeNode.renderingOrder = 101
        addChildNode(planeNode)
        planeNode.isHidden = true
    }
}
