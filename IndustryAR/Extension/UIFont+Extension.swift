//
//  UIFont+Extension.swift
//  Scene
//
//  Created by  吴 熠 on 2021/11/3.
//

import Foundation
import UIKit

extension UIFont {
    enum FontName: String {
    case title = ""
    case subTitle = "q"
    case content = "w"
    }

    class func titleFont(size: CGFloat) -> (UIFont) {
        let font = UIFont(name: FontName.title.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
        return font
    }

    class func subTitleFont(size: CGFloat) -> (UIFont) {
        let font = UIFont(name: FontName.subTitle.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
        return font
    }

    class func contentFont(size: CGFloat) -> (UIFont) {
        let font = UIFont(name: FontName.content.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
        return font
    }

    class func regularSize(size: CGFloat) -> (UIFont) {
        let font = UIFont(name: "PingFang-SC-Regular", size: size)!
        return font
    }

    class func mediumSize(size: CGFloat) -> (UIFont) {
        let font = UIFont(name: "PingFang-SC-Medium", size: size)!
        return font
    }

    class func boldSize(size: CGFloat) -> (UIFont) {
        let font = UIFont(name: "PingFang-SC-Semibold", size: size)!
        return font
    }
}

extension UIFont {
    var bold: UIFont {
        return with(.traitBold)
    }

    var italic: UIFont {
        return with(.traitItalic)
    }

    func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }

    func without(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(self.fontDescriptor.symbolicTraits.subtracting(UIFontDescriptor.SymbolicTraits(traits))) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}

extension Int {
    var font: UIFont {
        return UIFont.systemFont(ofSize: CGFloat(self))
    }
}

// MARK: - 注册字体
extension UIFont {
    static func registerFont(with directoryPath: String) -> Bool {
        let fontURL = URL(fileURLWithPath: directoryPath)
                
        guard let fontData = try? Data(contentsOf: fontURL),
              let fontDataProvider = CGDataProvider(data: fontData as CFData) else {
                  return false
              }
        
        guard let font = CGFont(fontDataProvider) else {
            return false
        }
        
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        guard success else {
            return false
        }
        
        return true
    }
}
