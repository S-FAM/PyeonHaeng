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
  
  private let fromSettings: Bool
  
  // MARK: - Init
  
  init(fromSettings: Bool) {
    self.fromSettings = fromSettings
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    
    if self.fromSettings {
      self.skipButton.setTitle(Strings.SelectStore.save, for: .normal)
    }
  }
  
  func bind(reactor: SelectStoreViewReactor) {
    if self.fromSettings {
      reactor.action.onNext(.selectStore(CVSStorage.shared.favoriteCVS, false, self.fromSettings))
    }
    
    // --- Action ---
    
    // CU 버튼 클릭
    self.selectStoreView.cuButton.rx.tap
      .compactMap { [unowned self] in
        SelectStoreViewReactor.Action.selectStore(.cu, self.selectStoreView.cuButton.isSelected, self.fromSettings)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // GS25 버튼 클릭
    self.selectStoreView.gsButton.rx.tap
      .compactMap { [unowned self] in
        SelectStoreViewReactor.Action.selectStore(.gs, self.selectStoreView.gsButton.isSelected, self.fromSettings)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // emart24 버튼 클릭
    self.selectStoreView.emartButton.rx.tap
      .compactMap { [unowned self] in
        SelectStoreViewReactor.Action.selectStore(.eMart, self.selectStoreView.emartButton.isSelected, self.fromSettings)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // 7-ELEVEn 버튼 클릭
    self.selectStoreView.sevenElevenButton.rx.tap
      .compactMap { [unowned self] in
        SelectStoreViewReactor.Action.selectStore(.sevenEleven, self.selectStoreView.sevenElevenButton.isSelected, self.fromSettings)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // MINISTOP 버튼 클릭
    self.selectStoreView.miniStopButton.rx.tap
      .compactMap { [unowned self] in
        SelectStoreViewReactor.Action.selectStore(.miniStop, self.selectStoreView.miniStopButton.isSelected, self.fromSettings)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // 건너뛰기 버튼 클릭
    self.skipButton.rx.tap
      .compactMap { [unowned self] in
        return self.fromSettings ? SelectStoreViewReactor.Action.save : SelectStoreViewReactor.Action.skip
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // --- State ---
    
    reactor.state
      .map { $0.updateSelectButton }
      .filter { $0 }
      .withUnretained(self)
      .bind { owner, _ in
        owner.updateButtonUI()
      }
      .disposed(by: disposeBag)
  }
  
  /// 저장된 '자주 가는 편의점' 정보에 맞게 버튼의 UI를 업데이트 합니다.
  private func updateButtonUI() {
    self.selectStoreView.hideCheckImage()
    
    switch CVSStorage.shared.favoriteCVS {
    case .cu:
      self.selectStoreView.showCheckImage(at: self.selectStoreView.cuButton)
    case .gs:
      self.selectStoreView.showCheckImage(at: self.selectStoreView.gsButton)
    case .eMart:
      self.selectStoreView.showCheckImage(at: self.selectStoreView.emartButton)
    case .sevenEleven:
      self.selectStoreView.showCheckImage(at: self.selectStoreView.sevenElevenButton)
    case .miniStop:
      self.selectStoreView.showCheckImage(at: self.selectStoreView.miniStopButton)
    case .all:
      self.selectStoreView.hideCheckImage()
    }
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
