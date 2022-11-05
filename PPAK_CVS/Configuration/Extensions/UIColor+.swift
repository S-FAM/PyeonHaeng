//
//  UIColor.swift
//  PPAK_CVS
//
//  Created by hyeonseok on 2022/09/26.
//

import UIKit

extension UIColor {

  convenience init(hex: Int, alpha: CGFloat = 1.0) {
    let components = (
      red: CGFloat((hex >> 16) & 0xff) / 255,
      green: CGFloat((hex >> 08) & 0xff) / 255,
      blue: CGFloat((hex >> 00) & 0xff) / 255
    )
    self.init(red: components.red, green: components.green, blue: components.blue, alpha: alpha)
  }
  
  /// 16진수 형태의 문자열로 UIColor를 생성합니다.
  /// - Parameters:
  ///   - hex: 16진수 형태의 문자열
  ///   - alpha: 불투명도, 0부터 1 사이의 값
  convenience init?(hex: String, alpha: CGFloat = 1.0) {
    var hexString = hex
    if hexString.hasPrefix("#") {
      hexString.removeFirst()
    }
    if hexString.hasPrefix("0x") {
      hexString.removeFirst(2)
    }
    
    guard let hexColor = Int(hexString, radix: 16) else { return nil }
    
    self.init(hex: hexColor, alpha: alpha)
  }
}

// MARK: - Store's SymbolColor
extension UIColor {

  static let cuBackGroundColor = UIColor(hex: 0x51485)
  static let cuFontColor = UIColor(hex: 0x9DC92A)
  static let gsBackGroundColor = UIColor(hex: 0x63514D)
  static let gsFontColor = UIColor(hex: 0x00D7F1)
  static let seBackGroundColor = UIColor(hex: 0xFF8329)
  static let seFontColor = UIColor(hex: 0x005B45)
  static let msBackGroundColor = UIColor(hex: 0x003893)
  static let msFontColor = UIColor(hex: 0xF0F0F0)
  static let emBackGroundColor = UIColor(hex: 0x56555B)
  static let emFontColor = UIColor(hex: 0xFFB41D)
}
