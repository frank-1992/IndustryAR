//
//  ShapeSetting.swift
//  IndustryAR
//
//  Created by 吴熠 on 2/28/23.
//

import UIKit

class ShapeSetting {
    static var lineColor: UIColor {
        get {
            return UserDefaults.lineColor.uiColor()
        }
        set {
            UserDefaults.lineColor = newValue.colorString()
        }
    }
    
    static var lineThickness: Float {
        get {
            if UserDefaults.lineThickness == 0 {
                return 10
            } else {
                return UserDefaults.lineThickness
            }
        }
        set {
            UserDefaults.lineThickness = newValue
        }
    } // mm
    
    static var lineType: LineType {
        get {
            if UserDefaults.lineType == 0 {
                return .normal
            } else {
                return .dash
            }
        }
        set {
            UserDefaults.lineType = newValue.rawValue
        }
    }
    
    static var lineLength: Float {
        get {
            if UserDefaults.lineLength == 0 {
                return 10
            } else {
                return UserDefaults.lineLength
            }
        }
        set {
            UserDefaults.lineLength = newValue
        }
    }//= 10 // mm
    
    static var textColor: UIColor {
        get {
            return UserDefaults.textColor.uiColor()
        }
        set {
            UserDefaults.textColor = newValue.colorString()
        }
    }
    
    static var fontSize: CGFloat {
        get {
            if UserDefaults.fontSize == 0 {
                return 10
            } else {
                return CGFloat(UserDefaults.fontSize)
            }
        }
        set {
            UserDefaults.fontSize = Float(newValue)
            ShapeSetting.textScale = Float(newValue/10 * 0.003)
        }
    }
    
    static var textScale: Float = 0.003
    static var fontName: String {
        get {
            return UserDefaults.fontName
        }
        set {
            UserDefaults.fontName = newValue
        }
    } //= "PingFang-SC-Regular"
    
    static var fontNameList: [String] = [String]()
}


extension UserDefaults {
    
    private static let klineColor = "IndustryAR-klineColor"
    static var lineColor: String {
        get {
            self.standard.string(forKey: klineColor) ?? "white"
        }
        set {
            self.standard.set(newValue, forKey: klineColor)
        }
    }
    
    private static let klineThickness = "IndustryAR-klineThickness"
    static var lineThickness: Float {
        get {
            self.standard.float(forKey: klineThickness)
        }
        set {
            self.standard.set(newValue, forKey: klineThickness)
        }
    }
    
    private static let klineType = "IndustryAR-klineType"
    static var lineType: Int {
        get {
            self.standard.integer(forKey: klineType)
        }
        set {
            self.standard.set(newValue, forKey: klineType)
        }
    }
    
    private static let klineLength = "IndustryAR-klineLength"
    static var lineLength: Float {
        get {
            self.standard.float(forKey: klineLength)
        }
        set {
            self.standard.set(newValue, forKey: klineLength)
        }
    }
    
    private static let ktextColor = "IndustryAR-ktextColor"
    static var textColor: String {
        get {
            self.standard.string(forKey: ktextColor) ?? "white"
        }
        set {
            self.standard.set(newValue, forKey: ktextColor)
        }
    }
    
    private static let kfontSize = "IndustryAR-kfontSize"
    static var fontSize: Float {
        get {
            self.standard.float(forKey: kfontSize)
        }
        set {
            self.standard.set(newValue, forKey: kfontSize)
        }
    }
    
    private static let kfontName = "IndustryAR-kfontName"
    static var fontName: String {
        get {
            self.standard.string(forKey: kfontName) ?? "PingFang-SC-Regular"
        }
        set {
            self.standard.set(newValue, forKey: kfontName)
        }
    }
}

extension String {
    func uiColor() -> UIColor {
        if self == StrokeColor.black.rawValue {
            return .black
        } else if self == StrokeColor.blue.rawValue {
            return .blue
        } else if self == StrokeColor.yellow.rawValue {
            return .yellow
        } else if self == StrokeColor.white.rawValue {
            return .white
        } else if self == StrokeColor.green.rawValue {
            return .green
        } else if self == StrokeColor.systemOrange.rawValue {
            return .systemOrange
        } else if self == StrokeColor.systemPink.rawValue {
            return .systemPink
        } else if self == StrokeColor.red.rawValue {
            return .red
        } else if self == StrokeColor.orange.rawValue {
            return .orange
        } else if self == StrokeColor.purple.rawValue {
            return .purple
        } else if self == StrokeColor.blue.rawValue {
            return .blue
        } else {
            return .white
        }
    }
}

extension UIColor {
    func colorString() -> String {
        if self == StrokeColor.black.uiColor {
            return StrokeColor.black.rawValue
        } else if self == StrokeColor.blue.uiColor {
            return StrokeColor.blue.rawValue
        } else if self == StrokeColor.yellow.uiColor {
            return StrokeColor.yellow.rawValue
        } else if self == StrokeColor.white.uiColor {
            return StrokeColor.white.rawValue
        } else if self == StrokeColor.green.uiColor {
            return StrokeColor.green.rawValue
        } else if self == StrokeColor.systemOrange.uiColor {
            return StrokeColor.systemOrange.rawValue
        } else if self == StrokeColor.systemPink.uiColor {
            return StrokeColor.systemPink.rawValue
        } else if self == StrokeColor.red.uiColor {
            return StrokeColor.red.rawValue
        } else if self == StrokeColor.orange.uiColor {
            return StrokeColor.orange.rawValue
        } else if self == StrokeColor.purple.uiColor {
            return StrokeColor.purple.rawValue
        } else if self == StrokeColor.blue.uiColor {
            return StrokeColor.blue.rawValue
        } else {
            return StrokeColor.white.rawValue
        }
    }
}
