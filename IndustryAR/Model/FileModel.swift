//
//  ContainerModel.swift
//  IndustryAR
//
//  Created by 吴熠 on 1/20/23.
//

import UIKit

class FileModel: NSObject {
    var fileName: String = ""
    var fileThumbnail: URL?
    var childDirectory: [URL] = [URL]()
}
