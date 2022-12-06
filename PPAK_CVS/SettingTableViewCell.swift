//
//  SettingTableViewCell.swift
//  PPAK_CVS
//
//  Created by hyeonseok on 2022/11/28.
//

import UIKit

import SnapKit
import Then

class SettingTableViewCell: UITableViewCell {

  // MARK: - Properties
  static let identifier = "SettingTableViewCell"
  private let iconList = ["icon_alert", "icon_noti", "icon_review", "icon_mail", "info_cheer", "icon_version"]
  private let titleList = ["알림", "공지사항", "리뷰 남기기", "문의하기", "개발자 응원하기", "버전정보"]

  private let containerView = UIView()
  private let iconImage = UIImageView().then {
    $0.tintColor = .black
  }

  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .regular)
  }

  private let versionInfoLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12, weight: .regular)
    $0.textColor = .gray
  }

  // MARK: setLayout
  func setUI(_ row: Int) {

    setLayouts()
    setupConstraints()
    setDetail(row)
  }

  private func setDetail(_ row: Int) {

    iconImage.image = UIImage(named: iconList[row])
    titleLabel.text = titleList[row]

    // 버전정보 셀
    let isVersionCell = row == 5
    [versionInfoLabel].forEach {

      let versionString = isVersionCell ? "v \(versionInfo())" : ""
      $0.attributedText = setTextSpacing(text: versionString)
      $0.isHidden = isVersionCell ? false : true
      $0.textAlignment = .right
    }

    // Accessory가 필요하지 않은 경우
    let isNotIndicatorCell = row == 4 || row == 5
    self.accessoryType =  isNotIndicatorCell ? .none : .disclosureIndicator
  }

  private func setLayouts() {

    addSubview(containerView)
    [iconImage, titleLabel, versionInfoLabel].forEach {
      containerView.addSubview($0)
    }
  }

  private func setupConstraints() {

    containerView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(30)
      $0.trailing.equalToSuperview().inset(20)
      $0.verticalEdges.equalToSuperview().inset(10)
      $0.centerY.equalToSuperview()
    }

    iconImage.snp.makeConstraints { make in
      make.width.height.equalTo(containerView.snp.height).multipliedBy(0.7)
      make.leading.centerY.equalToSuperview()
    }

    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(iconImage.snp.trailing).offset(20)
      make.centerY.equalToSuperview()
    }

    versionInfoLabel.snp.makeConstraints { make in
      make.trailing.equalTo(containerView.snp.trailing)
      make.centerY.equalToSuperview()
      make.width.equalTo(40)
      make.height.equalTo(20)
    }
  }

  /// 현재 앱의 버전정보를 알려주는 함수
  private func versionInfo() -> String {

    guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return ""}
    return appVersion
  }

  /// 텍스트의 자간을 세팅하는 함수
  private func setTextSpacing(text: String) -> NSAttributedString {
    let introduction = NSAttributedString(string: text).withLineSpacing(100)
    return introduction
  }
}
