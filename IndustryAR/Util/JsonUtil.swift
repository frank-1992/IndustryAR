//
//  JsonUtil.swift
//  IndustryAR
//
//  Created by 吴熠 on 2/18/23.
//
import UIKit
import HandyJSON

class JsonUtil: NSObject {
    
    static func jsonToModel(_ jsonStr:String,_ modelType:HandyJSON.Type) -> HandyJSON {
        if jsonStr == "" || jsonStr.count == 0 {
            #if DEBUG
                print("jsonoModel:字符串为空")
            #endif
            return SceneModel()
        }
        if let model = modelType.deserialize(from: jsonStr) as? SceneModel {
            return model
        } else {
            return modelType.init()
        }
       
        
    }
    
    static func modelToJson(_ model:SceneModel?) -> String {
        if model == nil {
            #if DEBUG
                print("modelToJson:model为空")
            #endif
             return ""
        }
        return (model?.toJSONString())!
    }
}
