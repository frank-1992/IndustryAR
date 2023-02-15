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
    
    
    private static let kHasAutoShowBottomMenu = "IndustryAR-kHasAutoShow"
    
    static var hasAutoShowBottomMenu: Bool {
        get {
            self.standard.bool(forKey: kHasAutoShowBottomMenu)
        }
        set {
            self.standard.set(newValue, forKey: kHasAutoShowBottomMenu)
        }
    }
}
