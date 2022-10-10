//
//  CVSDropdownView.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/09/27.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

enum CVSDropdownCase {
  case all
  case sevenEleven
  case gs
  case cu
  case emart
  case ministop
  case setting

  var imageName: String {
    switch self {
    case .all: return "logo_all"
    case .sevenEleven: return "logo_7eleven"
    case .gs: return "logo_gs25"
    case .cu: return "logo_cu"
    case .emart: return "logo_emart24"
    case .ministop: return "logo_ministop"
    case .setting: return "setting"
    }
  }
}

final class CVSDropdownView: UIView {

  // MARK: - Properties

  private lazy var allButton = createLogoButton(CVSDropdownCase.all.imageName)
  private lazy var elevenButton = createLogoButton(CVSDropdownCase.sevenEleven.imageName)
  private lazy var cuButton = createLogoButton(CVSDropdownCase.cu.imageName)
  private lazy var emartButton = createLogoButton(CVSDropdownCase.emart.imageName)
  private lazy var gsButton = createLogoButton(CVSDropdownCase.gs.imageName)
  private lazy var ministopButton = createLogoButton(CVSDropdownCase.ministop.imageName)
  private lazy var settingButton = createLogoButton(CVSDropdownCase.setting.imageName)

  private lazy var stackView = UIStackView(
    arrangedSubviews: [allButton, cuButton, gsButton, elevenButton, ministopButton, emartButton, settingButton]
  ).then {
    $0.spacing = 12
    $0.axis = .vertical
  }

  let buttonEventSubject = PublishSubject<CVSDropdownCase>()
  let disposeBag = DisposeBag()

  // MARK: - LifeCycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupStyles()
    setupLayout()
    setupConstraints()
    bind()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setup

  private func setupStyles() {
    backgroundColor = .white
    layer.cornerRadius = 16.0
    layer.shadowOpacity = 0.2
    layer.shadowColor = UIColor.black.cgColor
  }

  private func setupLayout() {
    addSubview(stackView)
  }

  private func setupConstraints() {
    stackView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(12)
    }
  }

  // MARK: - Bind

  private func bind() {

    // All 버튼 이벤트
    allButton.rx.tap
      .map { CVSDropdownCase.all }
      .bind(to: buttonEventSubject)
      .disposed(by: disposeBag)

    // CU 버튼 이벤트
    cuButton.rx.tap
      .map { CVSDropdownCase.cu }
      .bind(to: buttonEventSubject)
      .disposed(by: disposeBag)

    // GS 버튼 이벤트
    gsButton.rx.tap
      .map { CVSDropdownCase.gs }
      .bind(to: buttonEventSubject)
      .disposed(by: disposeBag)

    // Emart 버튼 이벤트
    emartButton.rx.tap
      .map { CVSDropdownCase.emart }
      .bind(to: buttonEventSubject)
      .disposed(by: disposeBag)

    // Ministop 버튼 이벤트
    ministopButton.rx.tap
      .map { CVSDropdownCase.ministop }
      .bind(to: buttonEventSubject)
      .disposed(by: disposeBag)

    // 7Eleven 버튼 이벤트
    elevenButton.rx.tap
      .map { CVSDropdownCase.sevenEleven }
      .bind(to: buttonEventSubject)
      .disposed(by: disposeBag)

    // Setting 버튼 이벤트
    settingButton.rx.tap
      .map { CVSDropdownCase.setting }
      .bind(to: buttonEventSubject)
      .disposed(by: disposeBag)
  }

  // MARK: - Helpers

  private func createLogoButton(_ name: String) -> UIButton {
    let button = UIButton()
    button.setImage(UIImage(named: name), for: .normal)
    button.snp.makeConstraints { make in
      make.width.height.equalTo(40)
    }

    return button
  }

  static func showDropdown(_ view: UIView) {
    view.isHidden = false
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
      view.layer.opacity = 1
    }
  }

  static func hideDropdown(_ view: UIView) {
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
      view.layer.opacity = 0
    } completion: { _ in
      view.isHidden = true
    }
  }
}
