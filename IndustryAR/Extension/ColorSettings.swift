//
//  ColorSettings.swift
//  Scene
//
//  Created by  吴 熠 on 2021/11/5.
//

import UIKit

extension UIColor {
    static let purpleBorderColor = SSColorWithHex(0x747BF9, 1.0)
    // MARK: StoryListCellColor
    static let lagoon = SSColorWithHex(0x4FCDA0, 1)
    static let pacific = SSColorWithHex(0x459BEA, 1)
    static let aqua = SSColorWithHex(0x69C9DE, 1)
    static let mongo = SSColorWithHex(0xE8CB63, 1)
    static let lilac = SSColorWithHex(0x9191FF, 1)
    static let carnation = SSColorWithHex(0xF5978A, 1)
    static let sepia = SSColorWithHex(0xE2A46A, 1)

    // MARK: Basic Color
    static let BWP = SSColorWithHex(0xFFFFFF, 1.0)
    static let BWS = SSColorWithHex(0xFFFFFF, 0.76)
    static let BWT = SSColorWithHex(0xFFFFFF, 0.36)
    static let BWQ = SSColorWithHex(0xFFFFFF, 0.18)
    static let black = SSColorWithHex(0x000000, 1.0)
    static let BDarkGrayP = SSColorWithHex(0x212028, 1.0)
    static let BDarkGrayS = SSColorWithHex(0x212028, 0.75)

    // MARK: Background Color
    static let lightBP = SSColorWithHex(0xFFFFFF, 1.0)
    static let lightBS = SSColorWithHex(0xF5F5F6, 1.0)
    static let lightBT = SSColorWithHex(0xFFFFFF, 1.0)
    static let darkBP = SSColorWithHex(0x1D1C1F, 1.0)
    static let darkBS = SSColorWithHex(0x2B2933, 1.0)
    static let darkBT = SSColorWithHex(0x38363F, 1.0)

    // MARK: Group Background Color
    static let lightGB = SSColorWithHex(0xF5F5F6, 1.0)
    static let lightGS = SSColorWithHex(0xFFFFFF, 1.0)
    static let lightGT = SSColorWithHex(0xF5F5F6, 1.0)
    static let darkGB = SSColorWithHex(0x151516, 1.0)
    static let darkGS = SSColorWithHex(0x2B2933, 1.0)
    static let darkGT = SSColorWithHex(0x38363F, 1.0)

    // MARK: Dark Elevated Color
    static let EP = SSColorWithHex(0xF5F5F6, 1.0)
    static let ES = SSColorWithHex(0xF5F5F6, 1.0)
    static let ET = SSColorWithHex(0xF5F5F6, 1.0)

    // MARK: Content Color
    static let lightCP = SSColorWithHex(0x1D1C22, 1.0)
    static let lightCS = SSColorWithHex(0x1D1C22, 0.72)
    static let lightCT = SSColorWithHex(0x1D1C22, 0.36)
    static let lightCQ = SSColorWithHex(0x1D1C22, 0.18)
    static let darkCP = SSColorWithHex(0xFFFFFF, 1.0)
    static let darkCS = SSColorWithHex(0xFFFFFF, 0.72)
    static let darkCT = SSColorWithHex(0xFFFFFF, 0.36)
    static let darkCQ = SSColorWithHex(0xFFFFFF, 0.18)


    // MARK: Seprator Color
    static let lightSP = SSColorWithHex(0x84858D, 0.2)
    static let lightSS = SSColorWithHex(0x84858D, 0.16)
    static let lightST = SSColorWithHex(0x84858D, 0.08)
    static let darkSP = SSColorWithHex(0x84858D, 0.36)
    static let darkSS = SSColorWithHex(0x84858D, 0.24)
    static let darkST = SSColorWithHex(0x84858D, 0.12)


    // MARK: Overlay Color
    static let lightOP = SSColorWithHex(0x000000, 0.42)
    static let lightOS = SSColorWithHex(0x000000, 0.32)
    static let darkOP = SSColorWithHex(0x1D1C1F, 0.95)
    static let darkOS = SSColorWithHex(0x1D1C1F, 0.8)


    // MARK: Theme Color
    static let lightThemeP = SSColorWithHex(0x5055B3, 1.0)
    static let darkThemeP = SSColorWithHex(0x5A60DA, 1.0)
    static let lightThemeS1 = SSColorWithHex(0x5055B3, 0.05)


    // MARK: 405 Coral-P
    static let lightCoralP = SSColorWithHex(0xE14C4C, 1.0)
    static let darkCoralP = SSColorWithHex(0xB94545, 1.0)


    // MARK: Mongo
    static let lightMongoP = SSColorWithHex(0xE4BF5E, 1.0)
    static let darkMongoP = SSColorWithHex(0xDAB75B, 1.0)


    // MARK: Tangerine
    static let lightTangerineP = SSColorWithHex(0xF8B355, 1.0)
    static let darkTangerineP = SSColorWithHex(0xD99538, 1.0)
    
    // MARK: TangerineS2
    static let darkTangerineS2 = darkTangerineP.withAlphaComponent(0.13)

    // MARK: Lagoon
    static let lightLagoonP = SSColorWithHex(0x4FCDA0, 1.0)
    static let darkLagoonP = SSColorWithHex(0x43BD92, 1.0)

    // MARK: PacificP
    static let lightPacificP = SSColorWithHex(0x459BEA, 1.0)
    static let darkPacificP = SSColorWithHex(0x3486D1, 1.0)


    // MARK: Iris
    static let lightIris = SSColorWithHex(0x5055B3, 1.0)
    static let darkIris = SSColorWithHex(0x7075F3, 1.0)
    static let lightIrisP = SSColorWithHex(0x5F66DC, 1.0)

    // MARK: Orchid
    static let lightOrchid = SSColorWithHex(0xAD5BEE, 1.0)
    static let darkOrchid = SSColorWithHex(0xA040EC, 1.0)

    // MARK: Light/Hollywood-P
    static let lightHollywoodP = SSColorWithHex(0xE14C4C, 1.0)
    static let darkHollywoodP = SSColorWithHex(0xCB5D5D, 1.0)

    static let lightHollywoodPS5 = SSColorWithHex(0xE26565, 0.5)
    
    // MARK: - LightAccent-S1
    static let lightAccentP = SSColorWithHex(0x6F59F7, 1.0)
    
    // MARK: - Gradient
    static let gradient = SSColorWithHex(0x8875FF, 1.0)
    
    // MARK: - Accent-G-P
    static let accentGP = SSColorWithHex(0x7660FF, 1.0)

    // MARK: - Light/NavBar
    static let lightNavBar = SSColorWithHex(0x000000, 1.0)
    
    // MARK: - tabbarLightColor
    static let tabbarLightColor = SSColorWithHex(0xF7F7F7, 0.9)
    
    // MARK: - lightGP
    static let lightGP = SSColorWithHex(0xF5F5F6, 1.0)
    
    // MARK: - textField的高亮阴影颜色
    static let textFieldShadowColor = UIColor(red: 0.435, green: 0.349, blue: 0.969, alpha: 0.16)
    
    // MARK: - lightiOSThick
    static let lightiOSThick = SSColorWithHex(0xFAFAFA, 0.93)
}

var SSColorWithHex: (NSInteger, CGFloat) -> UIColor = { hex, alpha in
    return UIColor.rgbaColorFromHex(rgb: hex, alpha: alpha)
}

extension UIColor {

    /**
     *  16进制 转 RGBA
     */
    class func rgbaColorFromHex(rgb: Int, alpha: CGFloat) -> UIColor {

        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: alpha)
    }

    /**
     *  16进制 转 RGB
     */
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
    /// hex 色值
    public class func hex(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        let tempStr = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let hexint = intFromHexString(tempStr)
        let color = UIColor(red: ((CGFloat) ((hexint & 0xFF0000) >> 16))/255, green: ((CGFloat) ((hexint & 0xFF00) >> 8))/255, blue: ((CGFloat) (hexint & 0xFF))/255, alpha: alpha)
        return color
    }

    /// 从Hex装换int
    private class func intFromHexString(_ hexString: String) -> UInt64 {
        let scanner = Scanner(string: hexString)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        var result: UInt64 = 0
        scanner.scanHexInt64(&result)
        return result
    }
}
