//
//  UIFont+.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/12/31.
//

import UIKit

extension UIFont {

  enum Family: String {
    case black = "Black"
    case bold = "Bold"
    case extraBold = "ExtraBold"
    case extraLight = "ExtraLight"
    case light = "Light"
    case medium = "Medium"
    case regular = "Regular"
    case semiBold = "SemiBold"
    case thin = "Thin"
  }

  /// ```
  /// (For example)
  /// UIFont.appFont(family: .regular, size: 15.0)
  /// ```
  static func appFont(family: Family, size: CGFloat) -> UIFont {
    let appFont = UIFont(name: "Pretendard-\(family.rawValue)", size: size)
    return appFont ?? UIFont.systemFont(ofSize: size)
  }

  static func accentFont(size: CGFloat) -> UIFont {
    let appFont = UIFont(name: "EF_jejudoldam", size: size)
    return appFont ?? UIFont.systemFont(ofSize: size)
  }
}
