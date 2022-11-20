//
//  UIApplication+.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/11/20.
//

import UIKit

extension UIApplication {

  class func topViewController(
    base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
  ) -> UIViewController? {
    if let presented = base?.presentedViewController {
      return topViewController(base: presented)
    }
    return base
  }
}
