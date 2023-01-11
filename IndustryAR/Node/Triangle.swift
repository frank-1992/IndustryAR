//
//  Triangle.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/10/23.
//

import UIKit
import SceneKit

class Triangle: SCNNode {
    static let size: Float = 0.17
    
    // Thickness of the focus square lines in meters.
    static let thickness: Float = 0.018
    
    // Scale factor for the focus square when it is closed, w.r.t. the original size.
    static let scaleForClosedSquare: Float = 0.5
    
    static let primaryColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
    
    // Color of the focus square fill.
    static let fillColor = #colorLiteral(red: 1, green: 0.9254901961, blue: 0.4117647059, alpha: 1)
    
    private var segments: [Segment] = []
    
    private let positioningNode = SCNNode()
    
    override init() {
        super.init()
        let s1 = Segment(name: "s1")
        let s2 = Segment(name: "s2")
        let s3 = Segment(name: "s3")
        segments = [s1, s2, s3]
        
        let sl: Float = 1  // segment length
        let c: Float = Square.thickness / 2
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
        
        
        positioningNode.eulerAngles.x = .pi / 2 // Horizontal
        positioningNode.simdScale = [1.0, 1.0, 1.0] * (Triangle.size * Triangle.scaleForClosedSquare)
        for segment in segments {
            positioningNode.addChildNode(segment)
        }
        
        addChildNode(positioningNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
