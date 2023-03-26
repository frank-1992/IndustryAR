//
//  FileManager.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/6/23.
//

import UIKit

let containerName = "ARAssets"
let historyName = "History"

class ARFileManager: NSObject {
    static let shared = ARFileManager()
    
    private override init() {}
    
    private var documentURL: URL!
    
    private let manager = FileManager.default
    
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
                let historyModel = HistoryModel()
                historyModel.fileName = dirName
                let dirURL = URL(fileURLWithPath: dirPath)
                let usdzURL = dirURL.appendingPathComponent(dirName + ".usdz")
                let screenShot = dirURL.appendingPathComponent(dirName + ".png")
                let scnFile = dirURL.appendingPathComponent(dirName + ".scn")
                if manager.fileExists(atPath: usdzURL.relativePath) {
                    historyModel.usdzPath = usdzURL
                }
                if manager.fileExists(atPath: screenShot.relativePath) {
                    historyModel.fileThumbnail = screenShot
                }
                if manager.fileExists(atPath: scnFile.relativePath) {
                    historyModel.fileSCNPath = scnFile
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
        } catch {
            print("error:\(error)")
        }
    }
    
    public func deleteFileWithFileName(name: String) {
        let historyURL = documentURL.appendingPathComponent(historyName, isDirectory: true)
        do {
            let path = historyURL.appendingPathComponent(name).relativePath
            try manager.removeItem(atPath: path)
        } catch {}
    }
}
