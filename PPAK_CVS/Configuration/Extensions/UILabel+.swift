//
//  UILabel+.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/09/24.
//

import UIKit

extension UILabel {

  /// OnboardingVC에 사용되는 설명 Label
  /// - Parameters:
  ///   - text: 텍스트
  ///   - textColor: 텍스트 색상
  ///   - font: 폰트
  func onboardingExplainLabel(text: String, textColor: UIColor, font: UIFont) {
    let label = self
    label.text = text
    label.textColor = textColor
    label.numberOfLines = 2
    label.textAlignment = .center
    label.font = font
  }
}
