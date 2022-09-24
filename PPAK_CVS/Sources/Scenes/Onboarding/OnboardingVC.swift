//
//  OnboardingViewController.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/09/24.
//

import Foundation

final class OnboardingViewController: BaseViewController {

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    // TODO: 건너띄기나 시작하기 버튼을 클릭했을 때 Userdefaults 값을 저장하도록 변경하기
    FTUXStorage().setFTUXStatus()
  }

  // MARK: - Setup

  override func setupLayouts() {
    super.setupLayouts()
  }

  override func setupConstraints() {
    super.setupConstraints()
  }

  override func setupStyles() {
    super.setupStyles()
  }
}
