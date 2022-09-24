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

  public init() {}

  public func getFTUXStatus() -> Bool {
    userDefaults.bool(forKey: key)
  }

  public func setFTUXStatus() {
    userDefaults.set(true, forKey: key)
  }
}
