//
//  OnboardingViewController.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/09/24.
//

import UIKit

import Lottie
import RxCocoa
// import RxGesture
import SnapKit
import Then

final class OnboardingViewController: BaseViewController {

  // MARK: - Properties
  var viewModel: OnboardingViewModel

  private lazy var animationView = AnimationView()

  private lazy var pageControl = UIPageControl().then {
    $0.numberOfPages = 3
    $0.pageIndicatorTintColor = Color.pageIndicator
    $0.currentPageIndicatorTintColor = Color.currentPageIndicator
  }

  private lazy var bottomCurveView = BottomCurveView().then {
    $0.backgroundColor = Color.bottomCurveViewBgColor
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

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    self.startLottieAnimation()
  }

  // MARK: - Setup

  init(viewModel: OnboardingViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func setupLayouts() {
    super.setupLayouts()

    [
      self.animationView,
      self.pageControl,
      self.bottomCurveView,
      self.titleLabel,
      self.descLabel,
      self.skipButton,
      self.nextButton
    ].forEach {
      view.addSubview($0)
    }
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

  override func bind() {
    self.setOnboardingData()

    // --- INPUT---

    // 건너뛰기 버튼 클릭
    self.skipButton.rx.tap
      .bind(to: self.viewModel.input.skipButtonEvent)
      .disposed(by: self.disposeBag)

    // 다음 버튼 클릭
    self.nextButton.rx.tap
      .bind(to: viewModel.input.nextButtonEvent)
      .disposed(by: disposeBag)

    /*
    // 스와이프 제스처
    self.view.rx
      .swipeGesture([.left, .right])
      .when(.recognized)
      .subscribe(onNext: { [weak self] gesture in
        guard let self = self else { return }

        switch gesture.direction {
        case .left:
          self.viewModel.input.swipeGestureDetector.onNext(.left)
        case .right:
          self.viewModel.input.swipeGestureDetector.onNext(.right)
        default:
          break
        }
      })
      .disposed(by: disposeBag)
     */

    // --- OUTPUT ---

    // currentPage가 변할 때 마다 적용
    self.viewModel.output.currentPage
      .bind { [weak self] currentPage in
        guard let self = self else { return }
        self.pageControl.currentPage = currentPage
        self.setCurrentPageUI()
        self.startLottieAnimation()
      }
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
    static let currentPageIndicator = UIColor.black // TODO: Color Model 정리되면 사용하기
    static let bottomCurveViewBgColor = UIColor.black // TODO: Color Model 정리되면 사용하기
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
