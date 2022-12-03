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

  static let identifier = "SettingTableViewCell"

  private let containerView = UIView()
  private let iconImage = UIImageView().then {
    $0.tintColor = .black
  }

  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .regular)
  }

  private let descriptionLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12, weight: .regular)
    $0.textColor = .gray
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  private let image = ["icon_alert", "icon_noti", "icon_review", "icon_mail", "info_cheer", "icon_version"]
  private let text = ["알림", "공지사항", "리뷰 남기기", "문의하기", "개발자 응원하기", "버전정보"]

  // MARK: setLayout
  func setUI(_ row: Int) {
    iconImage.image = UIImage(named: image[row])
    titleLabel.text = text[row]

    let isVersionCell = row == 5
    [descriptionLabel].forEach {
      $0.text = isVersionCell ? "v1.0" : ""
      $0.isHidden = isVersionCell ? false : true
    }

    addSubview(containerView)

    containerView.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(30)
      $0.verticalEdges.equalToSuperview().inset(10)
      $0.centerX.centerY.equalToSuperview()
    }

    [iconImage, titleLabel, descriptionLabel].forEach {
      containerView.addSubview($0)
    }

    iconImage.snp.makeConstraints { make in
      make.width.height.equalTo(containerView.snp.height).multipliedBy(0.7)
      make.leading.centerY.equalToSuperview()
    }

    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(iconImage.snp.trailing).offset(20)
      make.centerY.equalToSuperview()
    }

    descriptionLabel.snp.makeConstraints { make in
      make.trailing.equalTo(containerView.snp.trailing)
      make.centerY.equalToSuperview()
      make.width.equalTo(40)
      make.height.equalTo(20)
    }
  }
}
