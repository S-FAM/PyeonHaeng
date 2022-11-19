//
//  GoodsCell.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/09/21.
//
import UIKit

import Then
import SnapKit

final class GoodsCell: UICollectionViewCell {

  // MARK: - properties
  static let id = "GoodsCell"

  private let containerView = UIView().then {
    $0.layer.cornerRadius = 12.0
    $0.layer.shadowOffset = CGSize(width: 0, height: 5)
    $0.layer.shadowOpacity = 0.1
    $0.layer.shadowColor = UIColor.black.cgColor
    $0.backgroundColor = .white
  }

  private let goodsLabel = UILabel().then {
    $0.text = "코카)씨그랩피치탄산수350ML"
    $0.font = .systemFont(ofSize: 16.0, weight: .bold)
  }

  private let priceLabel = UILabel().then {
    $0.text = "1,500원"
    $0.font = .systemFont(ofSize: 16.0, weight: .light)
  }

  private let descriptionLabel = UILabel().then {
    $0.text = "(개당 750원)"
    $0.font = .systemFont(ofSize: 14.0, weight: .light)
  }

  private let goodsImage = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.backgroundColor = .blue
  }

  private let eventView = UIView().then {
    $0.layer.cornerRadius = 4.0
    $0.backgroundColor = .blue
  }

  private lazy var stackView = UIStackView().then { stackView in
    let horiStack = UIStackView(arrangedSubviews: [priceLabel, descriptionLabel])
    horiStack.axis = .horizontal
    horiStack.spacing = 2.0
    [goodsLabel, horiStack, descriptionButton].forEach {
      stackView.addArrangedSubview($0)
    }
      stackView.axis = .vertical
      stackView.spacing = 4.0
      stackView.alignment = .leading
  }

  private var titleLogoView: TitleLogoView!
  private var descriptionButton: UIButton!

  // MARK: - Setup

  /// 명시적으로 호출되어야 합니다.
  func setupCVS(cvs: CVSType, event: EventType) {
    setupButtons(cvs: cvs, event: event)
    setupLayouts()
    setupConstraints()
  }

  private func setupButtons(cvs: CVSType, event: EventType) {
    self.titleLogoView = TitleLogoView(cvsType: cvs)

    var config = UIButton.Configuration.filled()
    var container = AttributeContainer()
    container.foregroundColor = cvs.fontColor
    container.font = .systemFont(ofSize: 12)
    config.baseBackgroundColor = cvs.bgColor
    config.background.cornerRadius = 12
    config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 10)
    config.attributedTitle = AttributedString(
      event.rawValue,
      attributes: container
    )
    self.descriptionButton = UIButton(configuration: config)
  }

  private func setupLayouts() {
    [containerView, titleLogoView]
      .forEach { contentView.addSubview($0) }

    [stackView, goodsImage, eventView]
      .forEach { containerView.addSubview($0) }
  }

  private func setupConstraints() {
    containerView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(16.0)
      make.bottom.equalToSuperview()
      make.height.equalTo(100)
    }

    titleLogoView.snp.makeConstraints { make in
      make.trailing.equalTo(containerView.snp.trailing).offset(-12)
      make.height.equalTo(30)
    }

    goodsImage.snp.makeConstraints { make in
      make.width.height.equalTo(80)
      make.leading.equalToSuperview().inset(16)
      make.centerY.equalToSuperview()
    }

    stackView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(goodsImage.snp.trailing).offset(8.0)
    }
  }
}
