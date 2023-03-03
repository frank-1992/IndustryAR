//
//  ShapeSetting.swift
//  IndustryAR
//
//  Created by 吴熠 on 2/28/23.
//

import UIKit

class ShapeSetting: NSObject {
    static var lineColor: UIColor = .white
    static var lineThickness: Float = 10 // mm
    static var lineType: LineType = .normal
    static var lineLength: Float = 10 // mm
    static var textColor: UIColor = .white
    static var fontSize: CGFloat = 10 {
        didSet {
            ShapeSetting.textScale = Float(fontSize/10 * 0.003)
        }
    }
    static var textScale: Float = 0.003
    static var fontName: String = "PingFang-SC-Regular"
    
    static var fontNameList: [String] = [String]()
}
