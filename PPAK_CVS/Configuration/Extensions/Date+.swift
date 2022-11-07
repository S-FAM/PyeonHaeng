//
//  Date+.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/11/07.
//

import Foundation

extension Date {
  
  /// 년도
  var year: Int {
    Calendar.current.component(.year, from: self)
  }
  
  /// 월
  var month: Int {
    Calendar.current.component(.year, from: self)
  }
}
