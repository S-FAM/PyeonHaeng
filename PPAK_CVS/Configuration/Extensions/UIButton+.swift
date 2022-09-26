//
//  UIButton+.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/09/24.
//

import UIKit

extension UIButton {

  /// 반투명 버튼
  /// - Parameters:
  ///   - title: 타이틀
  ///   - font: 폰트
  ///   - titleColor : 타이틀색 (기본: 흰색)
  ///   - bgColor: 배경색 (기본: 흰색)
  ///   - alpha: 투명도 (기본: 20%)
  func withAlphaButton(
    title: String,
    font: UIFont,
    titleColor: UIColor = .white,
    bgColor: UIColor = .white,
    alpha: CGFloat = 0.2,
    radius: CGFloat = 20
  ) {
    let button = self
    button.setTitle(title, for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    button.titleLabel?.font = font
    button.backgroundColor = bgColor.withAlphaComponent(alpha)
    button.layer.cornerRadius = radius
    button.clipsToBounds = true
  }
}
