//
//  UserDefaults+Extension.swift
//  IndustryAR
//
//  Created by 吴熠 on 2/4/23.
//

import Foundation
import UIKit

extension UserDefaults {
    
    private static let kLineColor = "kLineColor"
    
    static var lineColor: UIColor {
        get {
            self.standard.object(forKey: kLineColor) as! UIColor
        }
        set {
            self.standard.set(newValue, forKey: kLineColor)
        }
    }
    
    
//    struct Settings {
//        var lineColor: StrokeColor = .white
//        var lineWidth: CGFloat = 0.002
//        var lineType: LineType = .normal
//        var textColor: StrokeColor = .white
//        var fontSize: CGFloat = 24
//        var fontName: String = "PingFang-SC-Medium"
//    }
}
