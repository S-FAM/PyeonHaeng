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

  private let logoView = UIView().then {
    $0.layer.cornerRadius = 15.0
    $0.backgroundColor = .blue
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
    [goodsLabel, horiStack].forEach {
      stackView.addArrangedSubview($0)
    }
      stackView.axis = .vertical
      stackView.spacing = 4.0
      stackView.alignment = .leading
  }

  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayouts()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setup

  private func setupLayouts() {
    [containerView, logoView]
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

    logoView.snp.makeConstraints { make in
      make.bottom.equalTo(containerView.snp.top).offset(8)
      make.trailing.equalTo(containerView.snp.trailing).offset(-24.0)
      make.height.equalTo(30.0)
      make.width.equalTo(100.0)
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
