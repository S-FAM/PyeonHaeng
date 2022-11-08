//
//  FilterDropdownView.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/09/27.
//

import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa

enum FilterDropdownCase {
  case ascending
  case descending
}

final class FilterDropdownView: UIView {

  // MARK: - Properties

  private lazy var ascendingButton = createButton("낮은가격순 ↓")
  private lazy var descendingButton = createButton("높은가격순 ↑")

  lazy var stackView = UIStackView().then {
    $0.addArrangedSubview(ascendingButton)
    $0.addArrangedSubview(descendingButton)
    $0.axis = .vertical
    $0.spacing = 4.0
  }

  let disposeBag = DisposeBag()
  let buttonEventSubject = PublishSubject<FilterDropdownCase>()

  // MARK: - Init

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
    layer.shadowOpacity = 0.2
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.cornerRadius = 12.0
  }

  private func setupLayout() {
    addSubview(stackView)
  }

  private func setupConstraints() {
    stackView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }

  // MARK: - Bind

  private func bind() {

    // 낮은가격순 터치
    ascendingButton.rx.tap
      .map { FilterDropdownCase.ascending }
      .bind(to: buttonEventSubject)
      .disposed(by: disposeBag)

    // 높은가격순 터치
    descendingButton.rx.tap
      .map { FilterDropdownCase.descending }
      .bind(to: buttonEventSubject)
      .disposed(by: disposeBag)
  }
}

// MARK: - Helpers

extension FilterDropdownView {
  private func createButton(_ title: String) -> UIButton {
    var config = UIButton.Configuration.plain()
    var container = AttributeContainer()
    container.font = .systemFont(ofSize: 16.0, weight: .bold)
    container.foregroundColor = .black
    config.attributedTitle = AttributedString(title, attributes: container)
    let button = UIButton(configuration: config)

    return button
  }
}
