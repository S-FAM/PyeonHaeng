//
//  NSAttributedString+.swift
//  PPAK_CVS
//
//  Created by hyeonseok on 2022/12/04.
//

import UIKit

extension NSAttributedString {

  ///  자간을 세팅한 String값을 리턴하는 함수
  /// - Parameter spacing: 글자간격
  func withLineSpacing(_ spacing: CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.lineSpacing = spacing
        attributedString.addAttribute(.paragraphStyle,
                                        value: paragraphStyle,
                                        range: NSRange(location: 0, length: string.count))
        return NSAttributedString(attributedString: attributedString)
    }
}
