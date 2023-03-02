//
//  SCNTextNode.swift
//  SCNTextNode
//
//
//  Created by 吴熠 on 2/23/23.
//

import SceneKit

public class SCNTextNode: SCNNode {
    
    var currentWidth: Float = 0
    var currentDepth: Float = 0

    init(text: String, textColor: UIColor = .systemRed, textFont: UIFont = UIFont(name: ShapeSetting.fontName, size: ShapeSetting.fontSize) ?? UIFont.systemFont(ofSize: 20), extrusionDepth: CGFloat = 0.01) {
        super.init()
        let text = SCNText(string: text, extrusionDepth: 0.01)
        text.font = textFont
        let material = SCNMaterial()
        material.diffuse.contents = textColor
        material.writesToDepthBuffer = false
        material.readsFromDepthBuffer = false
        text.materials = [material]
        let textNode = SCNNode(geometry: text)
        textNode.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
        
        let min = textNode.boundingBox.min * 0.01
        let max = textNode.boundingBox.max * 0.01
        let width = max.x - min.x
        let height = max.y - min.y
        let depth = max.z - min.z
        
        self.pivot = SCNMatrix4MakeTranslation(
            self.boundingBox.min.x,
            self.boundingBox.min.y,
            self.boundingBox.min.z
        )
        
        currentWidth = width
        currentDepth = depth
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
