//
//  Storage.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/12/25.
//

import Foundation

final class ProductStorage {

  static let shared = ProductStorage()

  private let key = "Storage"
  private let userDefaults = UserDefaults.standard
  private init() {}

  private(set) lazy var products: [ProductModel] = load() {
    didSet {
      if let encoded = try? JSONEncoder().encode(products) {
        userDefaults.set(encoded, forKey: key)
      }
    }
  }

  private func load() -> [ProductModel] {
    guard let data = userDefaults.object(forKey: key) as? Data else { return [] }
    if let products = try? JSONDecoder().decode([ProductModel].self, from: data) {
      return products
    } else {
      return []
    }
  }
  
  func add(_ from: ProductModel) {
    products.insert(from, at: 0)
  }

  func remove(_ target: ProductModel) {
    products = products.filter { $0 != target }
  }

  func contains(_ from: ProductModel) -> Bool {
    return products.contains(from)
  }

  func retrieve(
    cvs: CVSType = .all,
    event: EventType = .all,
    sort: SortType = .none,
    target: String = ""
  ) -> [ProductModel] {
    var newProducts: [ProductModel] = []

    newProducts = products
      .filter { target == "" ? true : $0.name.contains(target) }
      .filter { cvs == .all ? true : $0.store == cvs }
      .filter { event == .all ? true : $0.saleType == event }
      .sorted {
        switch sort {
        case .ascending:
          return $0.price < $1.price
        case .descending:
          return $0.price > $1.price
        case .none:
          return false
        }
      }

    return newProducts
  }
}
