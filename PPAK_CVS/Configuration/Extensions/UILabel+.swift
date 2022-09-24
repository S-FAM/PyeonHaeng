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
  ///   - alpha: 텍스트 투명도 (기본: 100%)
  ///   - fontSize: 폰트 크기
  ///   - fontWeight: 폰트 굵기
  func onboardingExplainLabel(
    text: String,
    alpha: CGFloat = 1,
    fontSize: CGFloat,
    fontWeight: UIFont.Weight
  ) {
    let label = self
    label.text = text
    label.textColor = .white.withAlphaComponent(alpha)
    label.numberOfLines = 2
    label.textAlignment = .center
    label.font = .systemFont(ofSize: fontSize, weight: fontWeight)
  }
}
