//
//  UserDefaults+Extension.swift
//  IndustryAR
//
//  Created by 吴熠 on 2/4/23.
//

import Foundation
import UIKit

extension UserDefaults {
    
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
