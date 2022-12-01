//
//  SettingTableViewCell.swift
//  PPAK_CVS
//
//  Created by hyeonseok on 2022/11/28.
//

import UIKit
import SnapKit

class SettingTableViewCell: UITableViewCell {

  static let identifier = "SettingTableViewCell"

  private let containerView = UIView()
  private let iconImage: UIImageView = {
    let imageView = UIImageView()
    imageView.tintColor = .black
    imageView.backgroundColor = .blue

    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .regular)
    label.backgroundColor = .blue
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 12, weight: .regular)
    label.textColor = .gray
    label.backgroundColor = .blue
    return label
  }()

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  // MARK: setLayout
  func setUI() {

    addSubview(containerView)
    containerView.backgroundColor = .systemGray

    containerView.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(30)
      $0.verticalEdges.equalToSuperview().inset(20)
      $0.centerX.centerY.equalToSuperview()
    }

    [iconImage, titleLabel, descriptionLabel].forEach {
      containerView.addSubview($0)
    }

    iconImage.snp.makeConstraints { make in
      make.width.height.equalTo(20)
      make.leading.centerY.equalToSuperview()
    }

    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(iconImage.snp.trailing).offset(10)
      make.centerY.equalToSuperview()
    }

    descriptionLabel.snp.makeConstraints { make in
      make.trailing.centerY.equalToSuperview()
    }

  }
}
