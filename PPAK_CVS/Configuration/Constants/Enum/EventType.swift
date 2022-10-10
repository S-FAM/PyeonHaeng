//
//  EventType.swift
//  PPAK_CVS
//
//  Created by hyeonseok on 2022/10/10.
//

import UIKit

/// Description
/// 이벤트의 종류를 가리키는 Enum Type
enum EventType {
  
  case onePlusOne
  case twoPlusOne
  case allEnText
  case allKrText
  
  var eventTitle: String {
    switch self {
    case .onePlusOne: return "1 + 1"
    case .twoPlusOne: return "2 + 1"
    case .allEnText: return "All"
    case .allKrText: return "전체"
    }
  }
  
}
