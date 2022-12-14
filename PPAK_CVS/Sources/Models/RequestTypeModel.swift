//
//  RequestTypeModel.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/11/08.
//

import Foundation

struct RequestTypeModel: Codable {
  let cvs: CVSType
  let event: EventType
  let sort: SortType

  enum CodingKeys: String, CodingKey {
    case cvs
    case event
    case sort = "order-by"
  }
}
