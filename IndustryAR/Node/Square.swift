//
//  Rectangle.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/10/23.
//

import UIKit
import SceneKit

class Square: SCNNode {
    static let size: Float = 0.17
    
    // Thickness of the focus square lines in meters.
    static let thickness: Float = 0.018
    
    // Scale factor for the focus square when it is closed, w.r.t. the original size.
    static let scaleForClosedSquare: Float = 0.5
    
    static var primaryColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        
    private var segments: [Segment] = []
    
    private let positioningNode = SCNNode()
    
    override init() {
        super.init()
        create()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        create()
    }
    
    override class var supportsSecureCoding: Bool {
        return true
    }
    
    private func create() {
        let s1 = Segment(name: "s1")
        let s2 = Segment(name: "s2")
        let s3 = Segment(name: "s3")
        let s4 = Segment(name: "s4")
        segments = [s1, s2, s3, s4]
        
        let sl: Float = 1  // segment length
        let c: Float = Square.thickness / 2
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

        
        positioningNode.eulerAngles.x = .pi / 2 // Horizontal
        positioningNode.simdScale = [1.0, 1.0, 1.0] * (Square.size * Square.scaleForClosedSquare)
        for segment in segments {
            positioningNode.addChildNode(segment)
        }
        addChildNode(positioningNode)
    }
}
