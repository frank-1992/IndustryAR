//
//  SphereNodesManager.swift
//  IndustryAR
//
//  Created by 吴熠 on 2/4/23.
//

import SceneKit

enum StrokeColor: String {
    case black = "black"
    case blue = "blue"
    case yellow = "yellow"
    case white = "white"
    case green = "green"
    case systemOrange = "systemOrange"
    case systemPink = "systemPink"
    case red = "red"
    case orange = "orange"
    case purple = "purple"
    
    var uiColor: UIColor {
        switch self {
        case .black:
            return UIColor.black
        case .blue:
            return UIColor.blue
        case .yellow:
            return UIColor.yellow
        case .white:
            return UIColor.white
        case .green:
            return UIColor.green
        case .systemOrange:
            return UIColor.systemOrange
        case .systemPink:
            return UIColor.systemPink
        case .red:
            return UIColor.red
        case .orange:
            return UIColor.orange
        case .purple:
            return UIColor.purple
        }
    }
}

class SphereNodesManager {

    private let defaultSphereRadius: CGFloat = 0.002

    // Creating thousands of nodes uses up a lot of memory so instead we use cloning. Reference spheres are created once and then cloned instead of creating new spheres every time.
    private lazy var blackReferenceSphereNode: SCNNode = {
        return createSphereNode(color: UIColor.black)
    }()
    
    private lazy var blueReferenceSphereNode: SCNNode = {
        return createSphereNode(color: UIColor.blue)
    }()
    
    private lazy var yellowReferenceSphereNode: SCNNode = {
        return createSphereNode(color: UIColor.yellow)
    }()
    
    private lazy var whiteReferenceSphereNode: SCNNode = {
        return createSphereNode(color: UIColor.white)
    }()
    
    private lazy var greenReferenceSphereNode: SCNNode = {
        return createSphereNode(color: UIColor.green)
    }()
    
    private lazy var systemOrangeReferenceSphereNode: SCNNode = {
        return createSphereNode(color: UIColor.systemOrange)
    }()
    
    private lazy var systemPinkReferenceSphereNode: SCNNode = {
        return createSphereNode(color: UIColor.systemPink)
    }()
    
    private lazy var redReferenceSphereNode: SCNNode = {
        return createSphereNode(color: UIColor.red)
    }()
    
    private lazy var orangeReferenceSphereNode: SCNNode = {
        return createSphereNode(color: UIColor.orange)
    }()
    
    private lazy var purpleReferenceSphereNode: SCNNode = {
        return createSphereNode(color: UIColor.purple)
    }()

    private func createSphereNode(color: UIColor) -> SCNNode {
        let sphere = SCNSphere(radius: defaultSphereRadius)
        sphere.firstMaterial?.diffuse.contents = color
        return SCNNode(geometry: sphere)
    }

    func getReferenceSphereNode(forStrokeColor color: StrokeColor) -> SCNNode {
        switch color {
        case .black:
            return blackReferenceSphereNode
        case .blue:
            return blueReferenceSphereNode
        case .yellow:
            return yellowReferenceSphereNode
        case .white:
            return whiteReferenceSphereNode
        case .green:
            return greenReferenceSphereNode
        case .systemOrange:
            return systemOrangeReferenceSphereNode
        case .systemPink:
            return systemPinkReferenceSphereNode
        case .red:
            return redReferenceSphereNode
        case .orange:
            return orangeReferenceSphereNode
        case .purple:
            return purpleReferenceSphereNode
        }
    }
}



