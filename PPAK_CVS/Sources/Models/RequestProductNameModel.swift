//
//  RequestProductNameModel.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/12/15.
//

import Foundation

struct RequestProductNameModel: Codable {
  var name: String
  var sort: SortType
  var offset: Int = 0
  var limit: Int = 10

  enum CodingKeys: String, CodingKey {
    case name
    case sort = "order-by"
    case offset
    case limit
  }
}
