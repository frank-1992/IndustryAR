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
            var usdzFilePaths: [URL] = []
            var scnFilePaths: [URL] = []
            var modelThumbnailPath: URL?
            for directory in contentsOfDirectory {
                if !directory.contains(".DS_Store") {
                    let modelName = directory
                    let childURL = url.appendingPathComponent(directory, isDirectory: true)
                    
                    guard let enumberatorAtURL = manager.enumerator(at: childURL,
                                                              includingPropertiesForKeys: nil,
                                                              options: .skipsHiddenFiles,
                                                                    errorHandler: nil) else { return }
                    
                    for urlObject in enumberatorAtURL.allObjects {
                        if let url = urlObject as? URL {
                            print("\(url.lastPathComponent)")
                            if url.lastPathComponent.contains(".usdz") {
                                usdzFilePaths.append(url)
                            }
                            if url.lastPathComponent.contains(".scn") {
                                scnFilePaths.append(url)
                            }
                            if url.lastPathComponent.contains(".jpg") || url.lastPathComponent.contains(".png") {
                                modelThumbnailPath = url
                            }
                        }
                    }
                    
                    let assetModel = AssetModel()
                    assetModel.modelName = modelName
                    if let modelThumbnailPath = modelThumbnailPath {
                        assetModel.modelThumbnailPath = modelThumbnailPath
                    }
                    assetModel.usdzFilePaths = usdzFilePaths
                    assetModel.scnFilePaths = scnFilePaths
                    assets.append(assetModel)
                }
            }
            completion(assets)
        } catch {
            print("error:\(error)")
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
