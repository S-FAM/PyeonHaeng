//
//  CVSDropdownView.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/09/27.
//

import UIKit

import SnapKit
import Then

final class CVSDropdownView: UIView {

  // MARK: - Properties

  private lazy var mock1 = mockView()
  private lazy var mock2 = mockView()
  private lazy var mock3 = mockView()
  private lazy var mock4 = mockView()
  private lazy var mock5 = mockView()
  private lazy var mock6 = mockView()
  private lazy var mock7 = mockView()

  // MARK: - LifeCycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupStyles()
    setupLayout()
    setupConstraints()
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
    [mock1, mock2, mock3, mock4, mock5, mock6, mock7]
      .forEach { addSubview($0) }
  }

  private func setupConstraints() {
    mock1.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(12)
      make.width.height.equalTo(40)
    }

    mock2.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(mock1.snp.bottom).offset(12)
      make.width.height.equalTo(40)
    }

    mock3.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(mock2.snp.bottom).offset(12)
      make.width.height.equalTo(40)
    }

    mock4.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(mock3.snp.bottom).offset(12)
      make.width.height.equalTo(40)
    }

    mock5.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(mock4.snp.bottom).offset(12)
      make.width.height.equalTo(40)
    }

    mock6.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(mock5.snp.bottom).offset(12)
      make.width.height.equalTo(40)
    }

    mock7.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(mock6.snp.bottom).offset(12)
      make.width.height.equalTo(40)
    }
  }

  // MARK: - Helpers

  // 임시 메서드입니다.
  private func mockView() -> UIView {
    let view = UIView()
    view.backgroundColor = .blue
    view.layer.cornerRadius = 20

    return view
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
