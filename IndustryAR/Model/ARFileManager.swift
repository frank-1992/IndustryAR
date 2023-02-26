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
    private let historyName = "History"
    
    public func setupAssetsContainer() {
        let urls: [URL] = manager.urls(for: .documentDirectory, in: .userDomainMask)
        self.documentURL = urls.first!
        
        
        let url = documentURL.appendingPathComponent(containerName, isDirectory: true)
        let historyURL = documentURL.appendingPathComponent(historyName, isDirectory: true)
        var isDirectory: ObjCBool = ObjCBool(false)
        let isExist = manager.fileExists(atPath: url.path, isDirectory: &isDirectory)
        let isExistHistory = manager.fileExists(atPath: historyURL.path, isDirectory: &isDirectory)
        if !isExist {
            do {
                try manager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("createDirectory error:\(error)")
            }
        }
        if !isExistHistory {
            do {
                try manager.createDirectory(at: historyURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("createDirectory error:\(error)")
            }
        }
    }
    
    public func getHistoryChilds(completion: @escaping (_ historyList: [HistoryModel]) -> Void) {
        do {
            let historyURL = documentURL.appendingPathComponent(historyName, isDirectory: true)
            let dirs = try manager.contentsOfDirectory(at: historyURL,
                                                                includingPropertiesForKeys: nil,
                                                                options: .skipsHiddenFiles)
            var historyList = [HistoryModel]()
            for childDir in dirs {
                let dirPath = childDir.relativePath
                let dirName = childDir.lastPathComponent
                print("名称: \(dirName)")
                let historyModel = HistoryModel()
                historyModel.fileName = dirName
                let dirURL = URL(fileURLWithPath: dirPath)
                let usdzURL = dirURL.appendingPathComponent(dirName + ".usdz")
                let screenShot = dirURL.appendingPathComponent(dirName + ".png")
                let scnFile = dirURL.appendingPathComponent(dirName + ".scn")
                let transformString = dirURL.appendingPathComponent(dirName + ".txt")
                if manager.fileExists(atPath: usdzURL.relativePath) {
                    historyModel.usdzPath = usdzURL
                }
                if manager.fileExists(atPath: screenShot.relativePath) {
                    historyModel.fileThumbnail = screenShot
                }
                if manager.fileExists(atPath: scnFile.relativePath) {
                    historyModel.fileSCNPath = scnFile
                }
                if manager.fileExists(atPath: transformString.relativePath) {
                    historyModel.fileTransformString = transformString
                }
                historyList.append(historyModel)
            }
            completion(historyList)
        } catch {
            print("error:\(error)")
        }
    }
    
    public func getDirectoryChilds(with dirURL: URL, completion: @escaping (_ asssetModel: AssetModel) -> Void) {
        do {
            let asset = AssetModel()
            var usdzFilePaths: [URL] = []
            var scnFilePaths: [URL] = []
            
            asset.assetName = dirURL.lastPathComponent
            let contentsOfDir = try manager.contentsOfDirectory(at: dirURL,
                                                                includingPropertiesForKeys: nil,
                                                                options: .skipsHiddenFiles)
            for child in contentsOfDir {
                if child.lastPathComponent.contains(".jpg") || child.lastPathComponent.contains(".png") || child.lastPathComponent.contains(".jpeg") {
                    print(child)
                    asset.assetThumbnailPath = child
                }
                if child.lastPathComponent.contains(".usdz") {
                    usdzFilePaths.append(child)
                }
                if child.lastPathComponent.contains(".scn") {
                    scnFilePaths.append(child)
                }
            }
            asset.usdzFilePaths = usdzFilePaths
            asset.scnFilePaths = scnFilePaths
            completion(asset)
        } catch {
            print("error:\(error)")
        }
    }
    
    
    // 遍历文件夹
    public func traverseContainer(completion: @escaping (_ projectModels: [FileModel]) -> Void) {
        let url = self.documentURL.appendingPathComponent(containerName, isDirectory: true)
        do {
            let contentsOfDirectory = try manager.contentsOfDirectory(atPath: url.path)
//            print("contentsOfDirectory:\(contentsOfDirectory)")
            
            var projectModels = [FileModel]()
            for directory in contentsOfDirectory {
                let projectModel = FileModel()
                if !directory.contains(".DS_Store") {
                    var containerChildDirectory: [URL] = [URL]()
                    let projectName = directory
                    projectModel.fileName = projectName
                    let innerProjectURL = url.appendingPathComponent(directory, isDirectory: true)
                    
                    let contentsOfContainer = try manager.contentsOfDirectory(at: innerProjectURL,
                                                                              includingPropertiesForKeys: nil,
                                                                              options: .skipsHiddenFiles)
                    for containerChild in contentsOfContainer {
                        if containerChild.lastPathComponent.contains(".jpg") || containerChild.lastPathComponent.contains(".png") || containerChild.lastPathComponent.contains(".jpeg") {
                            projectModel.fileThumbnail = containerChild
                        } else {
                            // Asset Directory
                            containerChildDirectory.append(containerChild)
                        }
                    }
                    projectModel.childDirectory = containerChildDirectory
                    
                    projectModels.append(projectModel)
                }
            }
            completion(projectModels)
            
//            var assets = [AssetModel]()
//            var usdzFilePaths: [URL] = []
//            var scnFilePaths: [URL] = []
//            var modelThumbnailPath: URL?
//            for directory in contentsOfDirectory {
//                if !directory.contains(".DS_Store") {
//                    let modelName = directory
//                    let childURL = url.appendingPathComponent(directory, isDirectory: true)
//
//                    guard let enumberatorAtURL = manager.enumerator(at: childURL,
//                                                              includingPropertiesForKeys: nil,
//                                                              options: .skipsHiddenFiles,
//                                                                    errorHandler: nil) else { return }
//
//                    for urlObject in enumberatorAtURL.allObjects {
//                        if let url = urlObject as? URL {
//                            print("\(url.lastPathComponent)")
//                            if url.lastPathComponent.contains(".usdz") {
//                                usdzFilePaths.append(url)
//                            }
//                            if url.lastPathComponent.contains(".scn") {
//                                scnFilePaths.append(url)
//                            }
//                            if url.lastPathComponent.contains(".jpg") || url.lastPathComponent.contains(".png") {
//                                modelThumbnailPath = url
//                            }
//                        }
//                    }
//
//                    let assetModel = AssetModel()
//                    assetModel.modelName = modelName
//                    if let modelThumbnailPath = modelThumbnailPath {
//                        assetModel.modelThumbnailPath = modelThumbnailPath
//                    }
//                    assetModel.usdzFilePaths = usdzFilePaths
//                    assetModel.scnFilePaths = scnFilePaths
//                    assets.append(assetModel)
//                }
//            }
//            completion(assets)
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
