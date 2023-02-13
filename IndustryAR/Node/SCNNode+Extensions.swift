//
//  SCNNode+Extensions.swift
//  FirstSKAR
//
//  Created by guoping sun on 2022/09/11.
//

//_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____DIPRO_START_2023/02/09_____VVVVVVVVVVVVVVVVVVVVVVVVVVVVV_____

import Foundation
import ARKit
import SceneKit

extension SCNNode {
    func getWorldBoundingBox() -> ( min: SCNVector3, max: SCNVector3) {
        var curMin,curMax: SCNVector3
        var p: SCNVector3
        
        
        let p0 = SCNVector3(self.boundingBox.min.x, self.boundingBox.min.y, self.boundingBox.min.z)
        p = self.convertPosition(p0, to: nil)
        curMin = p
        curMax = p
        
        let p1 = SCNVector3(self.boundingBox.max.x, self.boundingBox.min.y, self.boundingBox.min.z)
        p = self.convertPosition(p1, to: nil)
        if(curMin.x > p.x) {
            curMin.x = p.x
        }
        if(curMax.x < p.x) {
            curMax.x = p.x
        }
        if(curMin.y > p.y) {
            curMin.y = p.y
        }
        if(curMax.y < p.y) {
            curMax.y = p.y
        }
        if(curMin.z > p.z) {
            curMin.z = p.z
        }
        if(curMax.z < p.z) {
            curMax.z = p.z
        }
        
        let p2 = SCNVector3(self.boundingBox.min.x, self.boundingBox.max.y, self.boundingBox.min.z)
        p = self.convertPosition(p2, to: nil)
        if(curMin.x > p.x) {
            curMin.x = p.x
        }
        if(curMax.x < p.x) {
            curMax.x = p.x
        }
        if(curMin.y > p.y) {
            curMin.y = p.y
        }
        if(curMax.y < p.y) {
            curMax.y = p.y
        }
        if(curMin.z > p.z) {
            curMin.z = p.z
        }
        if(curMax.z < p.z) {
            curMax.z = p.z
        }
        
        let p3 = SCNVector3(self.boundingBox.max.x, self.boundingBox.max.y, self.boundingBox.min.z)
        p = self.convertPosition(p3, to: nil)
        if(curMin.x > p.x) {
            curMin.x = p.x
        }
        if(curMax.x < p.x) {
            curMax.x = p.x
        }
        if(curMin.y > p.y) {
            curMin.y = p.y
        }
        if(curMax.y < p.y) {
            curMax.y = p.y
        }
        if(curMin.z > p.z) {
            curMin.z = p.z
        }
        if(curMax.z < p.z) {
            curMax.z = p.z
        }
        
        let p4 = SCNVector3(self.boundingBox.min.x, self.boundingBox.min.y, self.boundingBox.max.z)
        p = self.convertPosition(p4, to: nil)
        if(curMin.x > p.x) {
            curMin.x = p.x
        }
        if(curMax.x < p.x) {
            curMax.x = p.x
        }
        if(curMin.y > p.y) {
            curMin.y = p.y
        }
        if(curMax.y < p.y) {
            curMax.y = p.y
        }
        if(curMin.z > p.z) {
            curMin.z = p.z
        }
        if(curMax.z < p.z) {
            curMax.z = p.z
        }
        
        let p5 = SCNVector3(self.boundingBox.max.x, self.boundingBox.min.y, self.boundingBox.max.z)
        p = self.convertPosition(p5, to: nil)
        if(curMin.x > p.x) {
            curMin.x = p.x
        }
        if(curMax.x < p.x) {
            curMax.x = p.x
        }
        if(curMin.y > p.y) {
            curMin.y = p.y
        }
        if(curMax.y < p.y) {
            curMax.y = p.y
        }
        if(curMin.z > p.z) {
            curMin.z = p.z
        }
        if(curMax.z < p.z) {
            curMax.z = p.z
        }
        
        let p6 = SCNVector3(self.boundingBox.min.x, self.boundingBox.max.y, self.boundingBox.max.z)
        p = self.convertPosition(p6, to: nil)
        if(curMin.x > p.x) {
            curMin.x = p.x
        }
        if(curMax.x < p.x) {
            curMax.x = p.x
        }
        if(curMin.y > p.y) {
            curMin.y = p.y
        }
        if(curMax.y < p.y) {
            curMax.y = p.y
        }
        if(curMin.z > p.z) {
            curMin.z = p.z
        }
        if(curMax.z < p.z) {
            curMax.z = p.z
        }
        
        let p7 = SCNVector3(self.boundingBox.max.x, self.boundingBox.max.y, self.boundingBox.max.z)
        p = self.convertPosition(p7, to: nil)
        if(curMin.x > p.x) {
            curMin.x = p.x
        }
        if(curMax.x < p.x) {
            curMax.x = p.x
        }
        if(curMin.y > p.y) {
            curMin.y = p.y
        }
        if(curMax.y < p.y) {
            curMax.y = p.y
        }
        if(curMin.z > p.z) {
            curMin.z = p.z
        }
        if(curMax.z < p.z) {
            curMax.z = p.z
        }

        return (curMin, curMax)
    }
    
    func getLocalBoundingBox(cadModelRoot: SCNNode) -> ( min: SCNVector3, max: SCNVector3) {
        var curMin,curMax: SCNVector3
        var p: SCNVector3

        let p0 = SCNVector3(self.boundingBox.min.x, self.boundingBox.min.y, self.boundingBox.min.z)
        p = self.convertPosition(p0, to: cadModelRoot)
        curMin = p
        curMax = p
        
        let p1 = SCNVector3(self.boundingBox.max.x, self.boundingBox.min.y, self.boundingBox.min.z)
        p = self.convertPosition(p1, to: cadModelRoot)
        if(curMin.x > p.x) {
            curMin.x = p.x
        }
        if(curMax.x < p.x) {
            curMax.x = p.x
        }
        if(curMin.y > p.y) {
            curMin.y = p.y
        }
        if(curMax.y < p.y) {
            curMax.y = p.y
        }
        if(curMin.z > p.z) {
            curMin.z = p.z
        }
        if(curMax.z < p.z) {
            curMax.z = p.z
        }
        
        let p2 = SCNVector3(self.boundingBox.min.x, self.boundingBox.max.y, self.boundingBox.min.z)
        p = self.convertPosition(p2, to: cadModelRoot)
        if(curMin.x > p.x) {
            curMin.x = p.x
        }
        if(curMax.x < p.x) {
            curMax.x = p.x
        }
        if(curMin.y > p.y) {
            curMin.y = p.y
        }
        if(curMax.y < p.y) {
            curMax.y = p.y
        }
        if(curMin.z > p.z) {
            curMin.z = p.z
        }
        if(curMax.z < p.z) {
            curMax.z = p.z
        }
        
        let p3 = SCNVector3(self.boundingBox.max.x, self.boundingBox.max.y, self.boundingBox.min.z)
        p = self.convertPosition(p3, to: cadModelRoot)
        if(curMin.x > p.x) {
            curMin.x = p.x
        }
        if(curMax.x < p.x) {
            curMax.x = p.x
        }
        if(curMin.y > p.y) {
            curMin.y = p.y
        }
        if(curMax.y < p.y) {
            curMax.y = p.y
        }
        if(curMin.z > p.z) {
            curMin.z = p.z
        }
        if(curMax.z < p.z) {
            curMax.z = p.z
        }
        
        let p4 = SCNVector3(self.boundingBox.min.x, self.boundingBox.min.y, self.boundingBox.max.z)
        p = self.convertPosition(p4, to: cadModelRoot)
        if(curMin.x > p.x) {
            curMin.x = p.x
        }
        if(curMax.x < p.x) {
            curMax.x = p.x
        }
        if(curMin.y > p.y) {
            curMin.y = p.y
        }
        if(curMax.y < p.y) {
            curMax.y = p.y
        }
        if(curMin.z > p.z) {
            curMin.z = p.z
        }
        if(curMax.z < p.z) {
            curMax.z = p.z
        }
        
        let p5 = SCNVector3(self.boundingBox.max.x, self.boundingBox.min.y, self.boundingBox.max.z)
        p = self.convertPosition(p5, to: cadModelRoot)
        if(curMin.x > p.x) {
            curMin.x = p.x
        }
        if(curMax.x < p.x) {
            curMax.x = p.x
        }
        if(curMin.y > p.y) {
            curMin.y = p.y
        }
        if(curMax.y < p.y) {
            curMax.y = p.y
        }
        if(curMin.z > p.z) {
            curMin.z = p.z
        }
        if(curMax.z < p.z) {
            curMax.z = p.z
        }
        
        let p6 = SCNVector3(self.boundingBox.min.x, self.boundingBox.max.y, self.boundingBox.max.z)
        p = self.convertPosition(p6, to: cadModelRoot)
        if(curMin.x > p.x) {
            curMin.x = p.x
        }
        if(curMax.x < p.x) {
            curMax.x = p.x
        }
        if(curMin.y > p.y) {
            curMin.y = p.y
        }
        if(curMax.y < p.y) {
            curMax.y = p.y
        }
        if(curMin.z > p.z) {
            curMin.z = p.z
        }
        if(curMax.z < p.z) {
            curMax.z = p.z
        }
        
        let p7 = SCNVector3(self.boundingBox.max.x, self.boundingBox.max.y, self.boundingBox.max.z)
        p = self.convertPosition(p7, to: cadModelRoot)
        if(curMin.x > p.x) {
            curMin.x = p.x
        }
        if(curMax.x < p.x) {
            curMax.x = p.x
        }
        if(curMin.y > p.y) {
            curMin.y = p.y
        }
        if(curMax.y < p.y) {
            curMax.y = p.y
        }
        if(curMin.z > p.z) {
            curMin.z = p.z
        }
        if(curMax.z < p.z) {
            curMax.z = p.z
        }

        return (curMin, curMax)
    }
    
    func getCadModelWorldBoundingBox(cadModelRoot: SCNNode) -> ( min: SCNVector3, max: SCNVector3) {
        var curMin,curMax: SCNVector3
        
        curMin = SCNVector3(Float.greatestFiniteMagnitude, Float.greatestFiniteMagnitude, Float.greatestFiniteMagnitude)
        curMax = SCNVector3(-Float.greatestFiniteMagnitude, -Float.greatestFiniteMagnitude, -Float.greatestFiniteMagnitude)
        
        //Traverse children
        let numberOfChildren = self.childNodes.count
        if(numberOfChildren > 0) {
            for i in 0...numberOfChildren - 1 {
                let childNode = self.childNodes[i]
                
                let childBBox = childNode.getCadModelWorldBoundingBoxChildren(cadModelRoot: cadModelRoot)
                
                if(curMin.x > childBBox.min.x) {
                    curMin.x = childBBox.min.x
                }
                if(curMin.y > childBBox.min.y) {
                    curMin.y = childBBox.min.y
                }
                if(curMin.z > childBBox.min.z) {
                    curMin.z = childBBox.min.z
                }
                    
                if(curMax.x < childBBox.max.x) {
                    curMax.x = childBBox.max.x
                }
                if(curMax.y < childBBox.max.y) {
                    curMax.y = childBBox.max.y
                }
                if(curMax.z < childBBox.max.z) {
                    curMax.z = childBBox.max.z
                }
            }
        }
        
        return (curMin, curMax)
    }
    
    func getCadModelWorldBoundingBoxChildren(cadModelRoot: SCNNode) -> ( min: SCNVector3, max: SCNVector3) {
        var curMin,curMax: SCNVector3
        
        curMin = SCNVector3(Float.greatestFiniteMagnitude, Float.greatestFiniteMagnitude, Float.greatestFiniteMagnitude)
        curMax = SCNVector3(-Float.greatestFiniteMagnitude, -Float.greatestFiniteMagnitude, -Float.greatestFiniteMagnitude)
        
        if(self.name == "MarkerRoot")
        {
            return (curMin, curMax)
        }
        /*
        if(self.name == "VirtualObject")
        {
            let bbox = self.getLocalBoundingBox(cadModelRoot: cadModelRoot);
            return bbox
        }
         */
        
        if(self.geometry != nil)
        {
            let points = getVertices(node: self)
            guard (points?.count) != nil else {
                return (curMin, curMax)
            }
            
            let bbox = self.getLocalBoundingBox(cadModelRoot: cadModelRoot);
            return bbox
        }
        
        //Traverse children
        let numberOfChildren = self.childNodes.count
        if(numberOfChildren > 0) {
            for i in 0...numberOfChildren - 1 {
                let childNode = self.childNodes[i]
                
                let childBBox = childNode.getCadModelWorldBoundingBoxChildren(cadModelRoot: cadModelRoot)
                
                if(curMin.x > childBBox.min.x) {
                    curMin.x = childBBox.min.x
                }
                if(curMin.y > childBBox.min.y) {
                    curMin.y = childBBox.min.y
                }
                if(curMin.z > childBBox.min.z) {
                    curMin.z = childBBox.min.z
                }
                    
                if(curMax.x < childBBox.max.x) {
                    curMax.x = childBBox.max.x
                }
                if(curMax.y < childBBox.max.y) {
                    curMax.y = childBBox.max.y
                }
                if(curMax.z < childBBox.max.z) {
                    curMax.z = childBBox.max.z
                }
            }
        }
        
        return (curMin, curMax)
    }
}

//_____AAAAAAAAAAAAAAAAAAAAAAAAAAAAA______DIPRO_END_2023/02/09______AAAAAAAAAAAAAAAAAAAAAAAAAAAAA_____
