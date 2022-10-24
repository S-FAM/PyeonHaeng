//
//  EventInfoResponseModel.swift
//  PPAK_CVS
//
//  Created by hyeonseok on 2022/10/20.
//

import Foundation

// MARK: - EventInfoResponseModel
struct EventInfoResponseModel: Codable {
  let enable: Bool
  let img, name, price, store, tag: String
  
  enum CodingKeys : String, CodingKey {
    
    case enable
    case name
    case price
    case store
    case tag
    case img = "image"
    
  }
}
