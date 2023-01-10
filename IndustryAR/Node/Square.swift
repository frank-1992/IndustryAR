//
//  Rectangle.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/10/23.
//

import UIKit
import SceneKit

enum Corner {
    case topLeft // s1, s3
    case topRight // s2, s4
    case bottomRight // s6, s8
    case bottomLeft // s5, s7
}

enum Alignment {
    case horizontal // s1, s2, s7, s8
    case vertical // s3, s4, s5, s6
}

enum Direction {
    case up, down, left, right

    var reversed: Direction {
        switch self {
            case .up:   return .down
            case .down: return .up
            case .left:  return .right
            case .right: return .left
        }
    }
}

class Square: SCNNode {
    static let size: Float = 0.17
    
    // Thickness of the focus square lines in meters.
    static let thickness: Float = 0.018
    
    // Scale factor for the focus square when it is closed, w.r.t. the original size.
    static let scaleForClosedSquare: Float = 0.97
    
    // Side length of the focus square segments when it is open (w.r.t. to a 1x1 square).
    static let sideLengthForOpenSegments: CGFloat = 0.2
    
    // Duration of the open/close animation
    static let animationDuration = 0.7
    
    static let primaryColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
    
    // Color of the focus square fill.
    static let fillColor = #colorLiteral(red: 1, green: 0.9254901961, blue: 0.4117647059, alpha: 1)
    
    private var segments: [Square.Segment] = []
    
    private let positioningNode = SCNNode()
    
    override init() {
        super.init()
        let s1 = Segment(name: "s1", corner: .topLeft, alignment: .horizontal)
        let s2 = Segment(name: "s2", corner: .topRight, alignment: .horizontal)
        let s3 = Segment(name: "s3", corner: .topLeft, alignment: .vertical)
        let s4 = Segment(name: "s4", corner: .topRight, alignment: .vertical)
        let s5 = Segment(name: "s5", corner: .bottomLeft, alignment: .vertical)
        let s6 = Segment(name: "s6", corner: .bottomRight, alignment: .vertical)
        let s7 = Segment(name: "s7", corner: .bottomLeft, alignment: .horizontal)
        let s8 = Segment(name: "s8", corner: .bottomRight, alignment: .horizontal)
        segments = [s1, s2, s3, s4, s5, s6, s7, s8]
        
        let sl: Float = 0.5  // segment length
        let c: Float = Square.thickness / 2 // correction to align lines perfectly
        s1.simdPosition += [-(sl / 2 - c), -(sl - c), 0]
        s2.simdPosition += [sl / 2 - c, -(sl - c), 0]
        s3.simdPosition += [-sl, -sl / 2, 0]
        s4.simdPosition += [sl, -sl / 2, 0]
        s5.simdPosition += [-sl, sl / 2, 0]
        s6.simdPosition += [sl, sl / 2, 0]
        s7.simdPosition += [-(sl / 2 - c), sl - c, 0]
        s8.simdPosition += [sl / 2 - c, sl - c, 0]
        
        positioningNode.eulerAngles.x = .pi / 2 // Horizontal
        positioningNode.simdScale = [1.0, 1.0, 1.0] * (Square.size * Square.scaleForClosedSquare)
        for segment in segments {
            positioningNode.addChildNode(segment)
        }
        
        addChildNode(positioningNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
