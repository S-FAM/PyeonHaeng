//
//  SelectStoreViewController.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2023/01/28.
//

import UIKit

import ReactorKit

final class SelectStoreViewController: BaseViewController, View {
  
  // MARK: - Properties
  
  private lazy var textContainer = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .center
    $0.distribution = .fill
    $0.spacing = 20
  }
  
  private lazy var titleLabel = UILabel().then {
    $0.text = Strings.SelectStore.title
    $0.onboardingExplainLabel(textColor: Color.titleLabel, font: Font.titleLabel)
  }
  
  private lazy var descLabel = UILabel().then {
    $0.text = Strings.SelectStore.description
    $0.onboardingExplainLabel(textColor: Color.descLabel, font: Font.descLabel)
  }
  
  private lazy var selectStoreView = SelectStoreView()
  
  private lazy var skipButton = UIButton().then {
    $0.setTitle(Strings.SelectStore.skip, for: .normal)
    $0.withAlphaButton(title: Strings.Onboarding.skip, font: Font.button)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    .lightContent
  }
  
  // MARK: - Setup
  
  override func setupLayouts() {
    super.setupLayouts()
    
    [self.textContainer, self.selectStoreView, self.skipButton].forEach {
      self.view.addSubview($0)
    }
    
    self.textContainer.addArrangedSubview(self.titleLabel)
    self.textContainer.addArrangedSubview(self.descLabel)
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    self.textContainer.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(Inset.textContainerTop)
      make.centerX.equalToSuperview()
    }
    
    self.selectStoreView.snp.makeConstraints { make in
      make.top.equalTo(self.textContainer.snp.bottom).offset(Offset.selectStoreView)
      make.centerX.equalToSuperview()
    }
    
    self.skipButton.snp.makeConstraints { make in
      make.bottom.equalToSuperview().inset(Inset.skipButtonBottom)
      make.centerX.equalToSuperview()
      make.width.equalTo(Width.button)
      make.height.equalTo(Height.button)
    }
  }
  
  override func setupStyles() {
    super.setupStyles()
    self.navigationController?.setNavigationBarHidden(true, animated: true)
    self.view.backgroundColor = CVSType.all.bgColor
  }
  
  func bind(reactor: SelectStoreViewReactor) {
    
    // --- Action ---
    
    // CU 버튼 클릭
    self.selectStoreView.cuButton.rx.tap
      .debug()
      .map { SelectStoreViewReactor.Action.selectStore(.cu) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // GS25 버튼 클릭
    self.selectStoreView.gsButton.rx.tap
      .debug()
      .map { SelectStoreViewReactor.Action.selectStore(.gs) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // emart24 버튼 클릭
    self.selectStoreView.emartButton.rx.tap
      .debug()
      .map { SelectStoreViewReactor.Action.selectStore(.eMart) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // 7-ELEVEn 버튼 클릭
    self.selectStoreView.sevenElevenButton.rx.tap
      .debug()
      .map { SelectStoreViewReactor.Action.selectStore(.sevenEleven) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // MINISTOP 버튼 클릭
    self.selectStoreView.miniStopButton.rx.tap
      .debug()
      .map { SelectStoreViewReactor.Action.selectStore(.miniStop) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // 건너뛰기 버튼 클릭
    self.skipButton.rx.tap
      .map { SelectStoreViewReactor.Action.skip }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
}

// MARK: - Constant Collection

extension SelectStoreViewController {

  private enum Font {
    static let titleLabel = UIFont.appFont(family: .extraBold, size: 22.0)
    static let descLabel = UIFont.appFont(family: .regular, size: 15.0)
    static let button = UIFont.appFont(family: .semiBold, size: 15.0)
  }

  private enum Color {
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
    static let textContainerTop = 100.0
    static let skipButtonBottom = 84.0
  }

  private enum Offset {
    static let selectStoreView = 62.0
  }
}
