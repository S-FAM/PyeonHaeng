//
//  ProductTarget.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/12/14.
//

import Foundation

import Alamofire

enum ProductTarget {
  case search(RequestTypeModel)
  case history(RequestHistoryModel)
}

extension ProductTarget: TargetType {

  var method: HTTPMethod {
    return .get
  }

  var path: String {
    let uri = "products"
    switch self {
    case .search:
      return "\(uri)/search"
    case .history:
      return "\(uri)/history"
    }
  }

  var parameters: Parameters {
    switch self {
    case .search(let model):
      return model.parameters
    case .history(let model):
      return model.parameters
    }
  }
}
