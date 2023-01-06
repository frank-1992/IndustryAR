//
//  FileManager.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/6/23.
//

import UIKit

class ARFileManager: NSObject {
    static let shared = ARFileManager()
    
    private override init() {}
    
    private var documentURL: URL!
    
    private let manager = FileManager.default
    
    private let containerName = "ARAssets"
    
    public func setupAssetsContainer() {
        let urls: [URL] = manager.urls(for: .documentDirectory, in: .userDomainMask)
        self.documentURL = urls.first!
        
        
        let url = self.documentURL.appendingPathComponent(containerName, isDirectory: true)
        var isDirectory: ObjCBool = ObjCBool(false)
        let isExist = manager.fileExists(atPath: url.path, isDirectory: &isDirectory)
        if !isExist {
            do {
                try manager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("createDirectory error:\(error)")
            }
        }
    }
    
    // 遍历文件夹
    public func traverseContainer(completion: @escaping (_ assetModels: [AssetModel]) -> Void) {
        let url = self.documentURL.appendingPathComponent(containerName, isDirectory: true)
        do {
            let contentsOfDirectory = try manager.contentsOfDirectory(atPath: url.path)
            print("contentsOfDirectory:\(contentsOfDirectory)")
            var assets = [AssetModel]()
            for directory in contentsOfDirectory {
                if !directory.contains(".DS_Store") {
                    let modelName = directory
                    let modelThumbnailPath = url.relativePath + "/" + directory + "/" + directory + ".jpg"
                    let modelFilePath = url.relativePath + "/" + directory + "/" + directory + ".usdz"
                    
                    let assetModel = AssetModel()
                    assetModel.modelName = modelName
                    assetModel.modelThumbnailPath = modelThumbnailPath
                    assetModel.modelFilePath = modelFilePath
                    
                    assets.append(assetModel)
                }
            }
            completion(assets)
        } catch {
            print("1.1 浅遍历 error:\(error)")
        }
//        // 1.2 浅遍历：包含完整路径
//        do {
//            let contentsOfDirectory = try manager.contentsOfDirectory(at: url,
//                                                                      includingPropertiesForKeys: nil,
//                                                                      options: .skipsHiddenFiles)
//            print("skipsHiddenFiles:\(contentsOfDirectory)")
//        } catch {
//            print("1.2 浅遍历 error:\(error)")
//        }
//
//        // 2.1 深度遍历：只有当前文件夹下的路径
//        let enumberatorAtPath = manager.enumerator(atPath: url.path)
//        print("2.1 深度遍历：\(enumberatorAtPath?.allObjects)")
//        // 2.2 深度遍历：包含完整路径
//        let enumberatorAtURL = manager.enumerator(at: url,
//                                                  includingPropertiesForKeys: nil,
//                                                  options: .skipsHiddenFiles,
//                                                  errorHandler: nil)
//        print("2.2 深度遍历：\(enumberatorAtURL?.allObjects)")
//
    }
    
}
