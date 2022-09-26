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

