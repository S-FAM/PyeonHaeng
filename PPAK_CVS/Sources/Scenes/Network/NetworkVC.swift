//
//  NetworkViewController.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/11/12.
//

import UIKit

final class NetworkViewController: BaseViewController {

  // MARK: - Properties

  private lazy var container = UIView().then {
    $0.backgroundColor = .darkGray
  }

  private lazy var warningText = UILabel().then {
    $0.text = Strings.Network.pleseCheckNetwork
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 15, weight: .bold)
    $0.numberOfLines = 2
  }

  private lazy var goToSettingsButton = UIButton().then {
    $0.withAlphaButton(
      title: Strings.Network.goToSettings,
      font: UIFont.systemFont(ofSize: 15.0, weight: .semibold),
      radius: 15
    )
    $0.addTarget(self, action: #selector(self.didTapGoToSettingsButton), for: .touchUpInside)
  }

  // MARK: - Setup

  override func setupLayouts() {
    super.setupLayouts()

    self.view.addSubview(self.container)

    self.container.addSubview(self.warningText)
    self.container.addSubview(self.goToSettingsButton)
  }

  override func setupConstraints() {
    super.setupConstraints()

    self.container.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(100)
    }

    self.goToSettingsButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().inset(20.0)
      make.top.equalToSuperview().inset(20.0)
      make.width.equalTo(100)
      make.height.equalTo(44)
    }

    self.warningText.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(20.0)
      make.trailing.equalTo(self.goToSettingsButton.snp.leading).inset(10.0)
      make.centerY.equalTo(self.goToSettingsButton)
    }
  }

  override func setupStyles() {
    self.view.backgroundColor = .clear
  }

  // MARK: - Custom Functions

  @objc private func didTapGoToSettingsButton() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
    }
  }
}
