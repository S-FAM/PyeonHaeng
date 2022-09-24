//
//  OnboardingViewController.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/09/24.
//

import Foundation
import SnapKit
import Then
import UIKit

final class OnboardingViewController: BaseViewController {

  // MARK: - Properties

  private lazy var bottomCurveView = BottomCurveView().then {
    $0.backgroundColor = .black
  }

  private lazy var titleLabel = UILabel().then {
    $0.onboardingExplainLabel(
      text: Strings.Onboarding.explainTitle1,
      fontSize: 22,
      fontWeight: .heavy
    )
  }

  private lazy var descLabel = UILabel().then {
    $0.onboardingExplainLabel(
      text: Strings.Onboarding.explainDesc1,
      alpha: 0.5,
      fontSize: 15,
      fontWeight: .regular
    )
  }

  private lazy var skipButton = UIButton().then {
    $0.withAlphaButton(title: Strings.Onboarding.skip)
  }
  private lazy var nextButton = UIButton().then {
    $0.withAlphaButton(title: Strings.Onboarding.next)
  }

  private lazy var startButton = UIButton().then {
    $0.withAlphaButton(title: Strings.Onboarding.start, fontSize: 20, radius: 30)
    $0.isHidden = true
  }

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    // TODO: 건너띄기나 시작하기 버튼을 클릭했을 때 Userdefaults 값을 저장하도록 변경하기
    FTUXStorage().setFTUXStatus()
  }

  // MARK: - Setup

  override func setupLayouts() {
    super.setupLayouts()

    [bottomCurveView, titleLabel, descLabel, skipButton, nextButton, startButton].forEach {
      view.addSubview($0)
    }
  }

  override func setupConstraints() {
    super.setupConstraints()

    let bottomInset: CGFloat = 70

    bottomCurveView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(view.frame.size.height * 0.6)
    }

    titleLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(bottomCurveView.snp.top).inset(150)
    }

    descLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(30)
    }

    skipButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(20)
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(bottomInset)
      make.width.equalTo(100)
      make.height.equalTo(50)
    }

    nextButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().inset(20)
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(bottomInset)
      make.width.equalTo(100)
      make.height.equalTo(50)
    }

    startButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(bottomInset)
      make.width.equalTo(180)
      make.height.equalTo(70)
    }
  }

  override func setupStyles() {
    super.setupStyles()

    view.backgroundColor = .white
  }
}
