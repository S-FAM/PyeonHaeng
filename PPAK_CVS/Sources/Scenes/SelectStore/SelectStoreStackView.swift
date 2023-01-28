//
//  SelectStoreStackView.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2023/01/28.
//

import UIKit

final class SelectStoreView: UIView {
  
  // MARK: - Properties
  
  private lazy var cuButton = makeCVSButton(type: .cu)
  private lazy var gsButton = makeCVSButton(type: .gs)
  private lazy var emartButton = makeCVSButton(type: .eMart)
  private lazy var sevenElevenButton = makeCVSButton(type: .sevenEleven)
  private lazy var miniStopButton = makeCVSButton(type: .miniStop)
  
  private lazy var firstHStackView = makeHStackView()
  private lazy var secondHStackView = makeHStackView()
  
  // MARK: - Init
  
  init() {
    super.init(frame: .zero)
    self.setupLayout()
    self.setupConstraints()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  private func setupLayout() {
    self.firstHStackView.addArrangedSubview(self.cuButton)
    self.firstHStackView.addArrangedSubview(self.gsButton)
    
    self.secondHStackView.addArrangedSubview(self.sevenElevenButton)
    self.secondHStackView.addArrangedSubview(self.miniStopButton)
    
    self.addSubview(self.firstHStackView)
    self.addSubview(self.emartButton)
    self.addSubview(self.secondHStackView)
  }
  
  private func setupConstraints() {
    
    [
      self.cuButton,
      self.gsButton,
      self.emartButton,
      self.sevenElevenButton,
      self.miniStopButton
    ].forEach {
      $0.snp.makeConstraints { make in
        make.width.height.equalTo(Width.button)
      }
    }
    
    self.firstHStackView.snp.makeConstraints { make in
      make.top.centerX.equalToSuperview()
    }
    
    self.emartButton.snp.makeConstraints { make in
      make.top.equalTo(self.firstHStackView.snp.bottom).offset(Offset.top)
      make.centerX.equalToSuperview()
    }
    
    self.secondHStackView.snp.makeConstraints { make in
      make.top.equalTo(self.emartButton.snp.bottom).offset(Offset.top)
      make.centerX.equalToSuperview()
    }
  }
}

extension SelectStoreView {
  
  private func makeCVSButton(type: CVSType) -> UIButton {
    let title = {
      switch type {
      case .sevenEleven:
        return "7\nELEVEn"
      case .miniStop:
        return "MINI\nSTOP"
      default:
        return type.rawValue
      }
    }
    
    let titleColor = {
      switch type {
      case .cu, .miniStop:
        return type.bgColor
      default:
        return type.fontColor
      }
    }
    
    let button = UIButton().then {
      $0.withAlphaButton(
        title: title(),
        font: Font.button,
        titleColor: titleColor(),
        alpha: 1.0,
        radius: 40.0
      )
    }
    
    button.titleLabel?.lineBreakMode = .byCharWrapping
    button.titleLabel?.textAlignment = .center
    return button
  }
  
  private func makeHStackView() -> UIStackView {
    let stackView = UIStackView().then {
      $0.axis = .horizontal
      $0.distribution = .fill
      $0.spacing = Spacing.stackiView
    }
    return stackView
  }
}

// MARK: - Constant Collection

extension SelectStoreView {
  
  private enum Font {
    static let button = UIFont.accentFont(size: 15.0)
  }
  
  private enum Offset {
    static let top = 16.0
  }
  
  private enum Spacing {
    static let stackiView = 64.0
  }
  
  private enum Width {
    static let button = 100.0
  }
}
