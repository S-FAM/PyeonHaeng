//
//  FTUXStorage.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/09/24.
//

import Foundation

final class FTUXStorage {

  private let key = "localStorage_is_already_come"
  private let userDefaults = UserDefaults.standard

  public func isAlreadyCome() -> Bool {
    self.userDefaults.bool(forKey: key)
  }

  public func saveFTUXStatus() {
    self.userDefaults.set(true, forKey: key)
  }
}
