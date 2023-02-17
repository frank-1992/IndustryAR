//
//  VirtualObject.swift
//  XYARKit
//
//  Created by user on 4/6/22.
//

import UIKit
import SceneKit
import ARKit


public enum ObjectAlignment: Int {
    case horizontal = 0
    case vertical = 1
}

@available(iOS 13.0, *)
public final class VirtualObject: SCNReferenceNode {
    
    /// object name
    public var modelName: String = ""
    public var modelURL: String = ""
    
    /// alignments - 'horizontal, vertical, any'
    public var allowedAlignment: ARRaycastQuery.TargetAlignment {
        return .any
    }
    
    /// object's  ARAnchor
    public var anchor: ARAnchor?
    
    /// raycastQuery info when place object
    public var raycastQuery: ARRaycastQuery?
    
    /// the associated tracked raycast used to place this object.
    public var raycast: ARTrackedRaycast?
    
    /// the most recent raycast result used for determining the initial location of the object after placement
    public var mostRecentInitialPlacementResult: ARRaycastResult?
    
    /// if associated anchor should be updated at the end of a pan gesture or when the object is repositioned
    public var shouldUpdateAnchor = false
    
    
    public init?(filePath: String, fileName: String) {
        super.init(url: URL(fileURLWithPath: filePath))
        self.modelURL = filePath
        self.load()
        self.name = fileName
        self.modelName = fileName
//        addHorizontalLight()
        setupHorizontalPivot()
    }
    
//    public override init?(url referenceURL: URL) {
//        super.init(url: referenceURL)
//        self.load()
//        setupHorizontalPivot()
//    }
    
    required init?(coder aDecoder: NSCoder) {        
        if let filePath = aDecoder.decodeObject(forKey: "modelURL") as? String,
            let fileName = aDecoder.decodeObject(forKey: "modelName") as? String {
            self.modelURL = filePath
            self.modelName = fileName
            
        }
        super.init(coder: aDecoder)
//        super.init(url: URL(fileURLWithPath: self.modelURL))
        self.load()
        self.name = self.modelName
        setupHorizontalPivot()
    }
    
    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(modelURL, forKey: "modelURL")
        aCoder.encode(modelName, forKey: "modelName")
    }
    
    public override class var supportsSecureCoding: Bool {
        return true
    }
    
    
    
    // MARK: - setup pivot
    public func setupHorizontalPivot() {
        self.pivot = SCNMatrix4MakeTranslation(
            0,
            self.boundingBox.min.y,
            0
        )
    }
    
    public func setupVerticalPivot() {
        let x = self.boundingBox.min.x + (self.boundingBox.max.x - self.boundingBox.min.x) / 2
        let y = self.boundingBox.min.y + (self.boundingBox.max.y - self.boundingBox.min.y) / 2
        let z = self.boundingBox.min.z
        
        self.pivot = SCNMatrix4MakeTranslation(
            x,
            y,
            z
        )
    }
    
    private func addHorizontalLight() {
        let light = SCNLight()
        light.type = .directional
        light.shadowColor = UIColor.black.withAlphaComponent(0.3)
        light.shadowRadius = 5
        light.shadowSampleCount = 5
        light.castsShadow = true
        light.shadowMode = .forward

        let shadowLightNode = SCNNode()
        shadowLightNode.light = light
        /// horizontal
        shadowLightNode.eulerAngles = SCNVector3(x: -.pi / 4, y: 0, z: 0)
        self.addChildNode(shadowLightNode)
    }
}

public extension VirtualObject {
    /// return existing virtual node
    static func existingObjectContainingNode(_ node: SCNNode) -> VirtualObject? {
        if let virtualObjectRoot = node as? VirtualObject {
            return virtualObjectRoot
        }
        
        guard let parent = node.parent else { return nil }
        
        return existingObjectContainingNode(parent)
    }
    
    static func minOne<T: Comparable>( _ seq: [T]) -> T {
        assert(!seq.isEmpty)
        return seq.reduce(seq[0]) {
            min($0, $1)
        }
    }
    
    static func maxOne<T: Comparable>( _ seq: [T]) -> T {
        assert(!seq.isEmpty)
        return seq.reduce(seq[0]) {
            max($0, $1)
        }
    }
}
