//
//  OnboardingDataModel.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/09/25.
//

import Foundation

struct OnboardingDataModel {
  let lottieName: String
  let title: String
  let description: String

  init(lottieName: String, title: String, description: String) {
    self.lottieName = lottieName
    self.title = title
    self.description = description
  }
}
