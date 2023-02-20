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

  private init() {}

  let didChangeCVS = PublishSubject<CVSType>()

  @UserDefaultsWrapper<CVSType>(key: "CVS", defaultValue: .all)
  private(set) var cvs

  func save(_ cvs: CVSType) {
    self.cvs = cvs
  }

  // MARK: - 자주 가는 편의점

  @UserDefaultsWrapper<CVSType>(key: "favoriteCVS", defaultValue: .all)
  private(set) var favoriteCVS

  func saveToFavorite(_ cvs: CVSType) {
    self.favoriteCVS = cvs
  }
}
