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
    
    static func jsonArrayToModel(_ jsonArrayStr:String, _ modelType:HandyJSON.Type) ->[SceneModel] {
        if jsonArrayStr == "" || jsonArrayStr.count == 0 {
        #if DEBUG
            print("jsonToModelArray:字符串为空")
        #endif
            return []
        }
        var modelArray:[SceneModel] = []
        let data = jsonArrayStr.data(using: String.Encoding.utf8)
        let peoplesArray = try! JSONSerialization.jsonObject(with:data!, options: JSONSerialization.ReadingOptions()) as? [AnyObject]
        for people in peoplesArray! {
            modelArray.append(dictionaryToModel(people as! [String : Any], modelType))
        }
        return modelArray
    }
    
    static func dictionaryToModel(_ dictionStr:[String:Any],_ modelType:HandyJSON.Type) -> SceneModel {
        if dictionStr.count == 0 {
        #if DEBUG
            print("dictionaryToModel:字符串为空")
        #endif
            return SceneModel()
        }
        return modelType.deserialize(from: dictionStr) as! SceneModel
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
