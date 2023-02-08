//
//  ColorSettings.swift
//  Scene
//
//  Created by  吴 熠 on 2021/11/5.
//

import UIKit

func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {

    if #available(iOS 13.0, *) {
        return UIColor { collection in
            return collection.userInterfaceStyle == .light ? light : dark
        }
    } else {
        // Fallback on earlier versions
        return light
    }
}

var ColorWithHex: (NSInteger, CGFloat) -> UIColor = { hex, alpha in
    return UIColor.rgbaColorFromHex(rgb: hex, alpha: alpha)
}

extension UIColor {
    class func rgbaColorFromHex(rgb: Int, alpha: CGFloat) -> UIColor {

        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: alpha)
    }

    class func rgbColorFromHex(rgb: Int) -> UIColor {

        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: 1.0)
    }

    class var randomColor: UIColor {
        let red = CGFloat(arc4random()%256) / 255.0
        let green = CGFloat(arc4random()%256) / 255.0
        let blue = CGFloat(arc4random()%256) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension UIColor {
    /// hex
    public class func hex(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        let tempStr = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let hexint = intFromHexString(tempStr)
        let color = UIColor(red: ((CGFloat) ((hexint & 0xFF0000) >> 16))/255, green: ((CGFloat) ((hexint & 0xFF00) >> 8))/255, blue: ((CGFloat) (hexint & 0xFF))/255, alpha: alpha)
        return color
    }

    /// Hex -> int
    private class func intFromHexString(_ hexString: String) -> UInt64 {
        let scanner = Scanner(string: hexString)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        var result: UInt64 = 0
        scanner.scanHexInt64(&result)
        return result
    }
}
