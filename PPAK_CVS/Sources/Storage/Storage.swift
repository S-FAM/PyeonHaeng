//
//  Storage.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/12/25.
//

import Foundation

final class Storage {
  
  static let shared = Storage()
  
  private let key = "Storage"
  private let userDefaults = UserDefaults.standard
  private init() {}
  
  private(set) var products: [ProductModel] = shared.load() {
    didSet {
      let encoder = JSONEncoder()
      if let encoded = try? encoder.encode(oldValue) {
        userDefaults.set(encoded, forKey: key)
      }
    }
  }
  
  func load() -> [ProductModel] {
    guard let data = userDefaults.object(forKey: key) as? Data else { return [] }
    let decoder = JSONDecoder()
    if let products = try? decoder.decode([ProductModel].self, from: data) {
      return products
    } else {
      return []
    }
  }
  
  func add(_ from: ProductModel) {
    products.insert(from, at: 0)
  }
  
  func remove(_ target: ProductModel) {
    // TODO: 특정 아이템을 어떻게 삭제할까?
  }

  func retrieve(
    cvs: CVSType = .all,
    event: EventType = .all,
    target: String?
  ) -> [ProductModel] {
    var newProducts: [ProductModel] = []
    
    if let target = target {
      
      for item in products {
        if item.store == cvs,
           item.saleType == event,
           item.name.contains(target) {
          newProducts.append(item)
        }
      }

    } else {
      
      for item in products {
        if item.store == cvs,
           item.saleType == event {
          newProducts.append(item)
        }
      }
    }
    
    return newProducts
  }
  
}
