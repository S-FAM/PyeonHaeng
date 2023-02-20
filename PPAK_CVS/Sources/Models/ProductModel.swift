//
//  ProductModel.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/11/06.
//

import Foundation

struct ProductModel: Codable, Equatable {
  /// 이미지 주소
  let imageLink: String?
  /// 물품명
  let name: String
  /// 할인행사 날짜
  let dateString: String
  /// 가격
  let price: Int
  /// 편의점 가게
  let store: CVSType
  /// 할인종류
  let saleType: EventType

  enum CodingKeys: String, CodingKey {
    case name
    case price
    case store
    case dateString = "date"
    case imageLink = "img"
    case saleType = "tag"
  }
}
