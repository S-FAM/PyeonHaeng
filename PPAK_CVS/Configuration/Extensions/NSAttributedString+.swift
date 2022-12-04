//
//  NSAttributedString+.swift
//  PPAK_CVS
//
//  Created by hyeonseok on 2022/12/04.
//

import UIKit

extension NSAttributedString {
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
