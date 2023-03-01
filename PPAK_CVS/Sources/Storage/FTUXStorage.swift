//
//  FTUXStorage.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/09/24.
//

import Foundation

final class FTUXStorage {

  @UserDefaultsWrapper<Bool>(key: "localStorage_is_already_come", defaultValue: false)
  private(set) var wasLaunchedBefore // 이전에 실행했던 적이 있는지 확인

  func saveFTUXStatus() {
    wasLaunchedBefore = true
  }
}
