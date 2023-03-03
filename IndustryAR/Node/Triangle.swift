//
//  Triangle.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/10/23.
//

import UIKit
import SceneKit

class Triangle: SCNNode {
    
    private var segments: [Segment] = []
        
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
        let centerLine = ShapeSetting.lineLength * 2
        let length = centerLine / sin(.pi/3)
        
        let s1 = Segment(name: "s1", lineLength: CGFloat(length/1000))
        let s2 = Segment(name: "s2", lineLength: CGFloat(length/1000))
        let s3 = Segment(name: "s3", lineLength: CGFloat(length/1000))
        segments = [s1, s2, s3]
        
        let sl: Float = length/1000
        let temp: Float = sl / 2 * sin(.pi / 3)
        s1.simdPosition = simd_float3(0, 0, temp)
        s1.simdRotation = simd_float4(0, 0, 1, .pi / 2)
        s1.simdLocalRotate(by: simd_quatf(angle: .pi / 2, axis: SIMD3(x: 0, y: 1, z: 0)))
        
        
        s2.simdPosition = simd_float3(-sl / 4, 0, 0)
        s2.simdRotation = simd_float4(1, 0, 0, .pi / 2)
        s2.simdLocalRotate(by: simd_quatf(angle: .pi / 6, axis: SIMD3(x: 0, y: 0, z: 1)))

        
        s3.simdPosition = simd_float3(sl / 4, 0, 0)
        s3.simdRotation = simd_float4(1, 0, 0, .pi / 2)
        s3.simdLocalRotate(by: simd_quatf(angle: -.pi / 6, axis: SIMD3(x: 0, y: 0, z: 1)))
        
        
        positioningNode.eulerAngles.x = .pi / 2
        positioningNode.simdScale = [1.0, 1.0, 1.0]
        for segment in segments {
            positioningNode.addChildNode(segment)
        }
        addChildNode(positioningNode)
        
        
        let plane = SCNPlane(width: CGFloat(length/2400), height: CGFloat(length/2400))
        plane.firstMaterial?.diffuse.contents = UIImage(named: "shanchu-ar")
        plane.firstMaterial?.writesToDepthBuffer = false
        plane.firstMaterial?.readsFromDepthBuffer = false
        let planeNode = SCNNode(geometry: plane)
        planeNode.name = "plane_for_hit"
        planeNode.simdPosition = simd_float3(0, -ShapeSetting.lineLength/2000, 0)
        addChildNode(planeNode)
        planeNode.isHidden = true
    }
}
