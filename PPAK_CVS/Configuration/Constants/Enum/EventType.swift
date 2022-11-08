//
//  EventType.swift
//  PPAK_CVS
//
//  Created by hyeonseok on 2022/10/10.
//

import UIKit

/// 이벤트의 종류를 가리키는 Enum Type
enum EventType: String, Codable, CaseIterable {
  case onePlusOne = "1+1"
  case twoPlusOne = "2+1"
  case all = "All"
}
