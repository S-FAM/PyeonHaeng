//
//  UIColor.swift
//  PPAK_CVS
//
//  Created by hyeonseok on 2022/09/26.
//

import UIKit

extension UIColor {

  /// 16진수의 정수형으로 UIColor를 생성합니다.
  /// - Parameters:
  ///   - hex: 16진수
  ///   - alpha: 불투명도, 0부터 1사이의 값
  convenience init(hex: UInt, alpha: CGFloat = 1.0) {
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

    let hexColor = UInt(hexString, radix: 16)!

    self.init(hex: hexColor, alpha: alpha)
  }
}

// MARK: - OnboardingPage's Color
extension UIColor {

  static let defaultBackgroundColor = UIColor(hex: "#030026")!
}
