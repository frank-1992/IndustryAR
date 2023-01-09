//
//  AssetModel.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/6/23.
//

import UIKit

public class AssetModel: NSObject {
    var modelName: String = ""
    var modelThumbnailPath: URL?
    var usdzFilePaths: [URL] = []
    var scnFilePaths: [URL] = []
}
