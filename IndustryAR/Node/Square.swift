//
//  Rectangle.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/10/23.
//

import UIKit
import SceneKit

class Square: SCNNode {
                
    private var segments: [Segment] = []
    
    private var deleteFlag: SCNNode = SCNNode()
    
    private let positioningNode = SCNNode()
    
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
        let s1 = Segment(name: "s1", lineLength: CGFloat(ShapeSetting.lineLength/1000) * 2)
        let s2 = Segment(name: "s2", lineLength: CGFloat(ShapeSetting.lineLength/1000) * 2)
        let s3 = Segment(name: "s3", lineLength: CGFloat(ShapeSetting.lineLength/1000) * 2)
        let s4 = Segment(name: "s4", lineLength: CGFloat(ShapeSetting.lineLength/1000) * 2)
        segments = [s1, s2, s3, s4]
        
        let sl: Float = ShapeSetting.lineLength/1000 * 2
        let c: Float = ShapeSetting.lineThickness / 2 / 10000
        s1.simdPosition = simd_float3(0, 0, -sl / 2)
        s1.simdRotation = simd_float4(0, 0, 1, .pi / 2)
        s1.simdLocalRotate(by: simd_quatf(angle: .pi / 2, axis: SIMD3(x: 0, y: 1, z: 0)))

        
        s2.simdPosition = simd_float3(-sl / 2 + c, 0, 0)
        s2.simdRotation = simd_float4(1, 0, 0, .pi / 2)

        
        s3.simdPosition = simd_float3(sl / 2 - c, 0, 0)
        s3.simdRotation = simd_float4(1, 0, 0, .pi / 2)
        
        s4.simdPosition = simd_float3(0, 0, sl / 2 - c / 2)
        s4.simdRotation = simd_float4(0, 0, 1, .pi / 2)
        s4.simdLocalRotate(by: simd_quatf(angle: .pi / 2, axis: SIMD3(x: 0, y: 1, z: 0)))

        
        positioningNode.eulerAngles.x = .pi / 2
        positioningNode.simdScale = [1.0, 1.0, 1.0]
        for segment in segments {
            positioningNode.addChildNode(segment)
        }
        addChildNode(positioningNode)
        
        let plane = SCNPlane(width: CGFloat(ShapeSetting.lineLength/1000), height: CGFloat(ShapeSetting.lineLength/1000))
        plane.firstMaterial?.diffuse.contents = UIImage(named: "shanchu-ar")
        plane.firstMaterial?.writesToDepthBuffer = false
        plane.firstMaterial?.readsFromDepthBuffer = false
        let planeNode = SCNNode(geometry: plane)
        planeNode.name = "plane_for_hit"
        planeNode.simdPosition = simd_float3(0, 0, 0)
        addChildNode(planeNode)
        deleteFlag = planeNode
//        deleteFlag.isHidden = true
    }
    
    func showDeleteFlag() {
        deleteFlag.isHidden = false
    }
    
    func hideDeleteFlag() {
        deleteFlag.isHidden = true
    }
}
