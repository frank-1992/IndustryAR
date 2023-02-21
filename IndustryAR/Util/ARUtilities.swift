//
//  ARUtilities.swift
//  XYARKit
//
//  Created by user on 4/6/22.
//

import UIKit
import ARKit
import CryptoKit

// MARK: - CGPoint extensions
extension CGPoint {
    init(_ vector: SCNVector3) {
        self.init(x: CGFloat(vector.x), y: CGFloat(vector.y))
    }
    
    var length: CGFloat {
        return sqrt(x * x + y * y)
    }
}

// MARK: - SCNNode extensions
extension SCNNode {
    var extents: SIMD3<Float> {
        let (min, max) = boundingBox
        return SIMD3(max) - SIMD3(min)
    }
}

// MARK: - float4x4 extensions
extension float4x4 {
    var translation: SIMD3<Float> {
        get {
            let translation = columns.3
            return [translation.x, translation.y, translation.z]
        }
        set(newValue) {
            columns.3 = [newValue.x, newValue.y, newValue.z, columns.3.w]
        }
    }

    var orientation: simd_quatf {
        return simd_quaternion(self)
    }

    init(uniformScale scale: Float) {
        self = matrix_identity_float4x4
        columns.0.x = scale
        columns.1.y = scale
        columns.2.z = scale
    }
}

// MARK: - UIGestureRecognizer extensions
extension UIGestureRecognizer {
    func center(in view: UIView) -> CGPoint? {
        guard numberOfTouches > 0 else { return nil }
        
        let first = CGRect(origin: location(ofTouch: 0, in: view), size: .zero)

        let touchBounds = (1..<numberOfTouches).reduce(first) { touchBounds, index in
            return touchBounds.union(CGRect(origin: location(ofTouch: index, in: view), size: .zero))
        }

        return CGPoint(x: touchBounds.midX, y: touchBounds.midY)
    }
}

// MARK: - SCNVector3 extensions
extension SCNVector3 {
    // from Apples demo APP
    static func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
        return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
    }
    
    /**
     * Negates the vector described by SCNVector3 and returns
     * the result as a new SCNVector3.
     */
    func negate() -> SCNVector3 {
        return self * -1
    }
    
    /**
     * Negates the vector described by SCNVector3
     */
    mutating func negated() -> SCNVector3 {
        self = negate()
        return self
    }
    
    /**
     * Returns the length (magnitude) of the vector described by the SCNVector3
     */
//    func length() -> Float {
//        return sqrtf(x*x + y*y + z*z)
//    }
    
    /**
     * Normalizes the vector described by the SCNVector3 to length 1.0 and returns
     * the result as a new SCNVector3.
     */
//    func normalized() -> SCNVector3 {
//        return self / length()
//    }
    
    /**
     * Normalizes the vector described by the SCNVector3 to length 1.0.
     */
//    mutating func normalize() -> SCNVector3 {
//        self = normalized()
//        return self
//    }
    
    /**
     * Calculates the distance between two SCNVector3. Pythagoras!
     */
//    func distance(vector: SCNVector3) -> Float {
//        return (self - vector).length()
//    }
    
    /**
     * Calculates the dot product between two SCNVector3.
     */
//    func dot(vector: SCNVector3) -> Float {
//        return x * vector.x + y * vector.y + z * vector.z
//    }
    
    /**
     * Calculates the cross product between two SCNVector3.
     */
//    func cross(vector: SCNVector3) -> SCNVector3 {
//        return SCNVector3Make(y * vector.z - z * vector.y, z * vector.x - x * vector.z, x * vector.y - y * vector.x)
//    }
        
    /// Calculate the magnitude of this vector
    var magnitude:SCNFloat {
        get {
            return sqrt(dot(vector: self))
        }
    }
    
    /**
     Calculate the angle between two vectors     
     */
    func angleBetweenVectors(_ vectorB:SCNVector3) -> SCNFloat {
        
        //cos(angle) = (A.B)/(|A||B|)
        let cosineAngle = (dot(vector: vectorB) / (magnitude * vectorB.magnitude))
        return SCNFloat(acos(cosineAngle))
    }
}

/**
 * Adds two SCNVector3 vectors and returns the result as a new SCNVector3.
 */
//func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
//    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
//}

/**
 * Increments a SCNVector3 with the value of another.
 */
func += ( left: inout SCNVector3, right: SCNVector3) {
    left = left + right
}

/**
 * Subtracts two SCNVector3 vectors and returns the result as a new SCNVector3.
 */
//func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
//    return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
//}

/**
 * Decrements a SCNVector3 with the value of another.
 */
func -= ( left: inout SCNVector3, right: SCNVector3) {
    left = left - right
}

/**
 * Multiplies two SCNVector3 vectors and returns the result as a new SCNVector3.
 */
func * (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x * right.x, left.y * right.y, left.z * right.z)
}

/**
 * Multiplies a SCNVector3 with another.
 */
func *= ( left: inout SCNVector3, right: SCNVector3) {
    left = left * right
}

/**
 * Multiplies the x, y and z fields of a SCNVector3 with the same scalar value and
 * returns the result as a new SCNVector3.
 */
//func * (vector: SCNVector3, scalar: Float) -> SCNVector3 {
//    return SCNVector3Make(vector.x * scalar, vector.y * scalar, vector.z * scalar)
//}

/**
 * Multiplies the x and y fields of a SCNVector3 with the same scalar value.
 */
//func *= ( vector: inout SCNVector3, scalar: Float) {
//    vector = vector * scalar
//}

/**
 * Divides two SCNVector3 vectors abd returns the result as a new SCNVector3
 */
//func / (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
//    return SCNVector3Make(left.x / right.x, left.y / right.y, left.z / right.z)
//}

/**
 * Divides a SCNVector3 by another.
 */
func /= ( left: inout SCNVector3, right: SCNVector3) {
    left = left / right
}

/**
 * Divides the x, y and z fields of a SCNVector3 by the same scalar value and
 * returns the result as a new SCNVector3.
 */
//func / (vector: SCNVector3, scalar: Float) -> SCNVector3 {
//    return SCNVector3Make(vector.x / scalar, vector.y / scalar, vector.z / scalar)
//}

/**
 * Divides the x, y and z of a SCNVector3 by the same scalar value.
 */
func /= ( vector: inout SCNVector3, scalar: Float) {
    vector = vector / scalar
}

/**
 * Negate a vector
 */
func SCNVector3Negate(vector: SCNVector3) -> SCNVector3 {
    return vector * -1
}

/**
 * Returns the length (magnitude) of the vector described by the SCNVector3
 */
func SCNVector3Length(vector: SCNVector3) -> Float
{
    return sqrtf(vector.x*vector.x + vector.y*vector.y + vector.z*vector.z)
}

/**
 * Returns the distance between two SCNVector3 vectors
 */
func SCNVector3Distance(vectorStart: SCNVector3, vectorEnd: SCNVector3) -> Float {
    return SCNVector3Length(vector: vectorEnd - vectorStart)
}

/**
 * Returns the distance between two SCNVector3 vectors
 */
func SCNVector3Normalize(vector: SCNVector3) -> SCNVector3 {
    return vector / SCNVector3Length(vector: vector)
}

/**
 * Calculates the dot product between two SCNVector3 vectors
 */
func SCNVector3DotProduct(left: SCNVector3, right: SCNVector3) -> Float {
    return left.x * right.x + left.y * right.y + left.z * right.z
}

/**
 * Calculates the cross product between two SCNVector3 vectors
 */
func SCNVector3CrossProduct(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.y * right.z - left.z * right.y, left.z * right.x - left.x * right.z, left.x * right.y - left.y * right.x)
}

/**
 * Calculates the SCNVector from lerping between two SCNVector3 vectors
 */
func SCNVector3Lerp(vectorStart: SCNVector3, vectorEnd: SCNVector3, t: Float) -> SCNVector3 {
    return SCNVector3Make(vectorStart.x + ((vectorEnd.x - vectorStart.x) * t), vectorStart.y + ((vectorEnd.y - vectorStart.y) * t), vectorStart.z + ((vectorEnd.z - vectorStart.z) * t))
}

/**
 * Project the vector, vectorToProject, onto the vector, projectionVector.
 */
func SCNVector3Project(vectorToProject: SCNVector3, projectionVector: SCNVector3) -> SCNVector3 {
    let scale: Float = SCNVector3DotProduct(left: projectionVector, right: vectorToProject) / SCNVector3DotProduct(left: projectionVector, right: projectionVector)
    let v: SCNVector3 = projectionVector * scale
    return v
}


//_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____DIPRO_START_2023/02/09_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____

/**
 * Get geometry vertices
 */
func getVertices(node:SCNNode) -> [SCNVector3]? {
    let geometry = node.geometry
    let sources = geometry?.sources(for: .vertex)
    
    guard let source = sources?.first else{return nil}
    let stride = source.dataStride / source.bytesPerComponent
    let offset = source.dataOffset / source.bytesPerComponent
    let vectorCount = source.vectorCount
    return source.data.withUnsafeBytes { dataBytes in
                let buffer: UnsafePointer<Float> = dataBytes.baseAddress!.assumingMemoryBound(to: Float.self)
        var result = Array<SCNVector3>()
        for i in 0...vectorCount - 1 {
            let start = i * stride + offset
            result.append(SCNVector3(buffer[start], buffer[start + 1], buffer[start + 2]))
        }
        return result
    }
}

/**
 * Get geometry normals
 */
func getNormals(node:SCNNode) -> [SCNVector3]? {
    let geometry = node.geometry
    let sources = geometry?.sources(for: .normal)
    
    guard let source = sources?.first else{return nil}
    let stride = source.dataStride / source.bytesPerComponent
    let offset = source.dataOffset / source.bytesPerComponent
    let normalCount = source.vectorCount
    return source.data.withUnsafeBytes { dataBytes in
                let buffer: UnsafePointer<Float> = dataBytes.baseAddress!.assumingMemoryBound(to: Float.self)
        var result = Array<SCNVector3>()
        for i in 0...normalCount - 1 {
            let start = i * stride + offset
            result.append(SCNVector3(buffer[start], buffer[start + 1], buffer[start + 2]))
        }
        return result
    }
}

/**
 * preset CAD Model
 */
func presetCadModel( cadModelNode: SCNNode, bPivot: Bool, bSubdLevel: Bool ) {
    
    let x = cadModelNode.boundingBox.min.x + (cadModelNode.boundingBox.max.x - cadModelNode.boundingBox.min.x) / 2
    let y = cadModelNode.boundingBox.min.y + (cadModelNode.boundingBox.max.y - cadModelNode.boundingBox.min.y) / 2
    let z = cadModelNode.boundingBox.min.z + (cadModelNode.boundingBox.max.z - cadModelNode.boundingBox.min.z) / 2
    
    if(bPivot) {
        cadModelNode.pivot = SCNMatrix4MakeTranslation(
            x,
            y,
            z
        )
    }
    
    presetNodeChildren(node: cadModelNode, bPivot: bPivot, bSubdLevel: bSubdLevel);
}

/**
 * preset CAD Model children
 */
func presetNodeChildren( node: SCNNode, bPivot: Bool, bSubdLevel: Bool )
{
    //Subdivision level
    if(node.geometry != nil)
    {
        let points = getVertices(node: node)
        guard (points?.count) != nil else {
            return
        }
        
        let geometry = node.geometry
        if(bSubdLevel) {
            geometry?.wantsAdaptiveSubdivision = false
            geometry?.subdivisionLevel = 0
        }
        
        let element = geometry?.elements[0]
        let primType = element?.primitiveType
        switch primType {
        case .triangles:
            break
        case .triangleStrip:
            break
        case .line:
            break
        case .point:
            break
        default:
            break
        }
    }
    
    //Traverse children
    let numberOfChildren = node.childNodes.count
    if(numberOfChildren > 0) {
        for i in 0...numberOfChildren - 1 {
            let childNode = node.childNodes[i]
            
            presetNodeChildren(node: childNode, bPivot: bPivot, bSubdLevel: bSubdLevel)
        }
    }
}

/**
 * convert radian to degree
 */
public func rad2deg( rad:Float ) -> Float {
    return rad * (Float) (180.0 /  Double.pi)
}

/**
 * convert degree to radian
 */
public func deg2rad( deg:Float ) -> Float{
   return deg * (Float)(Double.pi / 180)
}

/**
 * get Pan Direction For Rotation
 */
public func getPanDirectionForRotation(velocity: CGPoint) -> String {
    var panDirection:String = ""
    if ( velocity.x > 0 && velocity.x > abs(velocity.y) || velocity.x < 0 && abs(velocity.x) > abs(velocity.y) ){
        panDirection = "horizontal"
    }
    
    if ( velocity.y < 0 && abs(velocity.y) > abs(velocity.x) || velocity.y > 0 &&  velocity.y  > abs(velocity.x)) {
        panDirection = "vertical"
    }
    
    return panDirection
}

/**
 * get Pan Direction For Translation
 */
public func getPanDirectionForTranslation(velocity: CGPoint) -> String {
    var panDirection:String = ""
    
    let x = velocity.x
    let y = velocity.y
    let distance = sqrt(x * x + y * y)
    guard distance > 0 else { return panDirection }
    let localRadCos = abs(x) / distance
    var localRad = acos(localRadCos)
    localRad = localRad * 180.0 / CGFloat.pi;
    
    panDirection = ""
    if(localRad < 22.5) {
        panDirection = "x-axis"
    }
    else if(localRad > 67.5) {
        panDirection = "y-axis"
    }
    else {
        panDirection = "z-axis"
    }
    //else if(localRad >= 25 && localRad <= 65){
    //    panDirection = "z-axis"
    //}
    
    return panDirection
}

//_____AAAAAAAAAAAAAAAAAAAAAAAAAAAAA______DIPRO_END_2023/02/09______AAAAAAAAAAAAAAAAAAAAAAAAAAAAA_____


extension String {
    var md5: String {
        let digest = Insecure.MD5.hash(data: data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
