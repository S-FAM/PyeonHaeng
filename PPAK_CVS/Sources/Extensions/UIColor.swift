//
//  UIColor.swift
//  PPAK_CVS
//
//  Created by hyeonseok on 2022/09/26.
//

import Foundation
import UIKit

extension UIColor {
    
    /// static let exampleColor = RGB(red: 196, green: 22, blue: 28)
    static func RGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return self.RGBA(red: red, green: green, blue: blue, alpha: 1)
    }

    static func RGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}

extension UIColor {
    static func colorFromHex(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
