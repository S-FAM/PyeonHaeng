//
//  ReponseModel.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/12/15.
//

import Foundation

struct ResponseModel: Codable {
  let count: Int
  let products: [ProductModel]
}
