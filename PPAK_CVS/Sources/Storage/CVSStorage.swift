//
//  CVSStorage.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2023/01/24.
//

import Foundation

import RxSwift

final class CVSStorage {

  static let shared = CVSStorage()

  private let key = "CVS"
  private let favoriteCVSKey = "favoriteCVS"
  private let userDefaults = UserDefaults.standard
  private init() {}

  lazy var didChangeCVS = PublishSubject<CVSType>()

  lazy var cvs: CVSType = load() {
    didSet {
      if let encoded = try? JSONEncoder().encode(cvs) {
        userDefaults.set(encoded, forKey: key)
      }
    }
  }

  private func load() -> CVSType {
    guard let data = userDefaults.object(forKey: key) as? Data else { return .all }
    if let cvs = try? JSONDecoder().decode(CVSType.self, from: data) {
      return cvs
    } else {
      return .all
    }
  }

  func save(_ cvs: CVSType) {
    self.cvs = cvs
  }

  // --- 자주 가는 편의점 ---

  lazy var favoriteCVS: CVSType = self.loadFavoriteCVS() {
    didSet {
      if let encoded = try? JSONEncoder().encode(self.favoriteCVS) {
        self.userDefaults.set(encoded, forKey: self.favoriteCVSKey)
      }
    }
  }

  private func loadFavoriteCVS() -> CVSType {
    guard let data = userDefaults.object(forKey: self.favoriteCVSKey) as? Data else {
      return .all
    }

    if let cvs = try? JSONDecoder().decode(CVSType.self, from: data) {
      return cvs
    } else {
      return .all
    }
  }

  func saveToFavorite(_ cvs: CVSType) {
    self.favoriteCVS = cvs
  }
}
