//
//  OnboardingViewController.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/09/24.
//

import Foundation
import UIKit

import SnapKit
import Then

final class OnboardingViewController: BaseViewController {

  // MARK: - Properties

  private lazy var bottomCurveView = BottomCurveView().then {
    $0.backgroundColor = Color.bottomCurveViewBgColor
  }

  private lazy var titleLabel = UILabel().then {
    $0.onboardingExplainLabel(
      text: Strings.Onboarding.explainTitle1,
      textColor: Color.titleLabel,
      font: Font.titleLabel
    )
  }

  private lazy var descLabel = UILabel().then {
    $0.onboardingExplainLabel(
      text: Strings.Onboarding.explainDesc1,
      textColor: Color.descLabel,
      font: Font.descLabel
    )
  }

  private lazy var skipButton = UIButton().then {
    $0.withAlphaButton(title: Strings.Onboarding.skip, font: Font.smallButton)
  }
  private lazy var nextButton = UIButton().then {
    $0.withAlphaButton(title: Strings.Onboarding.next, font: Font.smallButton)
  }

  private lazy var startButton = UIButton().then {
    $0.withAlphaButton(
      title: Strings.Onboarding.start,
      font: Font.largeButton,
      radius: Radius.largeButton
    )
    $0.isHidden = true
  }

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    // TODO: 건너뛰기나 시작하기 버튼을 클릭했을 때 Userdefaults 값을 저장하도록 변경하기
    FTUXStorage().saveFTUXStatus()
  }

  // MARK: - Setup

  override func setupLayouts() {
    super.setupLayouts()

    [self.bottomCurveView,
     self.titleLabel,
     self.descLabel,
     self.skipButton,
     self.nextButton,
     self.startButton
    ].forEach {
      view.addSubview($0)
    }
  }

  override func setupConstraints() {
    super.setupConstraints()

    self.bottomCurveView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(view.frame.size.height * Ratio.bottomCurveViewHeight)
    }

    self.titleLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(bottomCurveView.snp.top).inset(Inset.top)
    }

    self.descLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(Inset.label)
    }

    self.skipButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(Inset.side)
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Inset.bottom)
      make.width.equalTo(Width.smallButton)
      make.height.equalTo(Height.smallButton)
    }

    self.nextButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().inset(Inset.side)
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Inset.bottom)
      make.width.equalTo(Width.smallButton)
      make.height.equalTo(Height.smallButton)
    }

    self.startButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Inset.bottom)
      make.width.equalTo(Width.largeButton)
      make.height.equalTo(Height.largeButton)
    }
  }

  override func setupStyles() {
    super.setupStyles()

    view.backgroundColor = Color.viewBgColor
  }
}

// MARK: - Constant Collection

extension OnboardingViewController {

  private enum Font {
    static let titleLabel = UIFont.systemFont(ofSize: 22.0, weight: .heavy)
    static let descLabel = UIFont.systemFont(ofSize: 15.0, weight: .regular)
    static let smallButton = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
    static let largeButton = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
  }

  private enum Color {
    static let viewBgColor = UIColor.white
    static let bottomCurveViewBgColor = UIColor.black
    static let titleLabel = UIColor.white
    static let descLabel = UIColor.white.withAlphaComponent(0.5)
  }

  private enum Radius {
    static let largeButton = 30.0
  }

  private enum Width {
    static let smallButton = 100.0
    static let largeButton = 180.0
  }

  private enum Height {
    static let smallButton = 50.0
    static let largeButton = 70.0
  }

  private enum Inset {
    static let top = 150.0
    static let bottom = 70.0
    static let side = 20.0
    static let label = 30.0
  }

  private enum Ratio {
    static let bottomCurveViewHeight = 0.6
  }
}
