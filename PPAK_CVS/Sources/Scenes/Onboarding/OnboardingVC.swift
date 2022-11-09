//
//  OnboardingViewController.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/09/24.
//

import AVFoundation
import UIKit

import Lottie
import RxCocoa
import RxGesture
import SnapKit
import Then

final class OnboardingViewController: BaseViewController, Viewable {

  // MARK: - Properties

  private lazy var animationView = AnimationView()

  private lazy var pageControl = UIPageControl().then {
    $0.numberOfPages = 3
    $0.pageIndicatorTintColor = Color.pageIndicator
    $0.currentPageIndicatorTintColor = Color.currentPageIndicator
  }

  private lazy var bottomCurveView = BottomCurveView().then {
    $0.backgroundColor = Color.bottomCurveViewBgColor
  }

  private lazy var textContainer = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .center
    $0.distribution = .fill
    $0.spacing = 20
  }

  private lazy var titleLabel = UILabel().then {
    $0.onboardingExplainLabel(textColor: Color.titleLabel, font: Font.titleLabel)
  }

  private lazy var descLabel = UILabel().then {
    $0.onboardingExplainLabel(textColor: Color.descLabel, font: Font.descLabel)
  }

  private lazy var skipButton = UIButton().then {
    $0.withAlphaButton(title: Strings.Onboarding.skip, font: Font.button)
  }
  private lazy var nextButton = UIButton().then {
    $0.withAlphaButton(title: Strings.Onboarding.next, font: Font.button)
  }

  private var onboardingData: [OnboardingDataModel] = []

  // MARK: - Life Cycle

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.startLottieAnimation()
  }

  // MARK: - Setup

  override func setupLayouts() {
    super.setupLayouts()

    [
      self.animationView,
      self.pageControl,
      self.bottomCurveView,
      self.textContainer,
      self.skipButton,
      self.nextButton
    ].forEach {
      view.addSubview($0)
    }

    self.textContainer.addArrangedSubview(self.titleLabel)
    self.textContainer.addArrangedSubview(self.descLabel)
  }

  override func setupConstraints() {
    super.setupConstraints()

    self.animationView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.bottom.equalTo(bottomCurveView.snp.top)
    }

    self.pageControl.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(bottomCurveView.snp.top).offset(Offset.pageControl)
    }

    self.bottomCurveView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(view.frame.size.height * Ratio.bottomCurveViewHeight)
    }

    self.textContainer.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(bottomCurveView.snp.top).inset(Inset.top)
    }

    self.skipButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(Inset.side)
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Inset.bottom)
      make.width.equalTo(Width.button)
      make.height.equalTo(Height.button)
    }

    self.nextButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().inset(Inset.side)
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Inset.bottom)
      make.width.equalTo(Width.button)
      make.height.equalTo(Height.button)
    }
  }

  override func setupStyles() {
    super.setupStyles()
    view.backgroundColor = Color.viewBgColor
  }

  func bind(viewModel: OnboardingViewModel) {
    self.setOnboardingData()

    // --- Action ---

    // 건너뛰기 버튼 클릭
    self.skipButton.rx.tap
      .map { OnboardingViewModel.Action.skip }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 다음 버튼 클릭
    self.nextButton.rx.tap
      .map { OnboardingViewModel.Action.next }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 왼쪽 스와이프 제스처
    self.view.rx.swipeGesture(.left)
      .when(.recognized)
      .map { _ in OnboardingViewModel.Action.leftSwipe }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 오른쪽 스와이프 제스처
    self.view.rx.swipeGesture(.right)
      .when(.recognized)
      .map { _ in OnboardingViewModel.Action.rightSwipe }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // --- State ---

    // 현재 페이지가 변할 때
    viewModel.state.map { $0.currentPage }
      .distinctUntilChanged()
      .bind { [weak self] currentPage in
        self?.pageControl.currentPage = currentPage
        self?.setCurrentPageUI()
        self?.startLottieAnimation()
        self?.changePageEffect()
      }
      .disposed(by: disposeBag)
  }
}

// MARK: - Custom Functions

extension OnboardingViewController {

  private func setOnboardingData() {
    self.onboardingData.append(contentsOf: [
      OnboardingDataModel(
        lottieName: Strings.Onboarding.lottie1,
        title: Strings.Onboarding.title1,
        description: Strings.Onboarding.desc1
      ),
      OnboardingDataModel(
        lottieName: Strings.Onboarding.lottie2,
        title: Strings.Onboarding.title2,
        description: Strings.Onboarding.desc2
      ),
      OnboardingDataModel(
        lottieName: Strings.Onboarding.lottie3,
        title: Strings.Onboarding.title3,
        description: Strings.Onboarding.desc3
      )
    ])
  }

  private func setCurrentPageUI() {
    let currentPage = self.pageControl.currentPage
    let lottieName = self.onboardingData[currentPage].lottieName

    self.animationView.animation = Animation.named(lottieName)
    self.titleLabel.text = self.onboardingData[currentPage].title
    self.descLabel.text = self.onboardingData[currentPage].description
  }

  private func startLottieAnimation() {
    self.animationView.play()
    self.animationView.loopMode = .loop
  }

  private func changePageEffect() {
    AudioServicesPlaySystemSound(1520)
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.textContainer.alpha = 1
      self?.textContainer.layoutIfNeeded()
    }
  }
}

// MARK: - Constant Collection

extension OnboardingViewController {

  private enum Font {
    static let titleLabel = UIFont.systemFont(ofSize: 22.0, weight: .heavy)
    static let descLabel = UIFont.systemFont(ofSize: 15.0, weight: .regular)
    static let button = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
  }

  private enum Color {
    static let viewBgColor = UIColor.white
    static let pageIndicator = UIColor.lightGray
    static let currentPageIndicator = CVSType.all.bgColor
    static let bottomCurveViewBgColor = CVSType.all.bgColor
    static let titleLabel = UIColor.white
    static let descLabel = UIColor.white.withAlphaComponent(0.5)
  }

  private enum Width {
    static let button = 100.0
  }

  private enum Height {
    static let button = 50.0
  }

  private enum Inset {
    static let top = 150.0
    static let bottom = 70.0
    static let side = 20.0
    static let label = 30.0
  }

  private enum Offset {
    static let pageControl = 20.0
  }

  private enum Ratio {
    static let bottomCurveViewHeight = 0.6
  }
}
