//
//  RequestTypeModel.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/11/08.
//

import Foundation

struct RequestTypeModel: Codable {
  var cvs: CVSType
  var event: EventType
  var sort: SortType
  var name: String?
  var offset: Int = 0
  var limit: Int = 20

  enum CodingKeys: String, CodingKey {
    case cvs
    case event
    case sort = "order-by"
    case name
    case offset
    case limit
  }
}
