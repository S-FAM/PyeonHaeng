//
//  Int+.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2023/01/02.
//

import Foundation

extension Int {
  var commaRepresentation: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter.string(from: NSNumber(value: self)) ?? ""
  }
}
