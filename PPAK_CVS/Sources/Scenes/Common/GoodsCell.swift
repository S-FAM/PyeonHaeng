//
//  GoodsCell.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/09/21.
//
import UIKit

import Kingfisher
import SnapKit
import Then

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
    $0.font = .appFont(family: .bold, size: 14)
  }

  private let priceLabel = UILabel().then {
    $0.font = .appFont(family: .regular, size: 14)
  }

  private let goodsImage = UIImageView().then {
    $0.image = UIImage(named: "ic_noImage_small")
    $0.contentMode = .scaleAspectFit
  }

  private lazy var stackView = UIStackView().then { stackView in
    [goodsLabel, priceLabel, saleTypeView].forEach {
      stackView.addArrangedSubview($0)
    }
      stackView.axis = .vertical
      stackView.spacing = 6
      stackView.alignment = .leading
  }

  private let titleLogoView = TitleLogoView(cvsType: .all)
  private let saleTypeView = SaleTypeView(cvsType: .all)

  // MARK: - LifeCycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupStyles()
    setupLayouts()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setup

  private func setupStyles() {}

  private func setupLayouts() {
    [containerView, titleLogoView]
      .forEach { contentView.addSubview($0) }

    [stackView, goodsImage]
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
      make.centerY.equalTo(containerView.snp.top).offset(4)
    }

    goodsImage.snp.makeConstraints { make in
      make.width.height.equalTo(80)
      make.leading.equalToSuperview().inset(16)
      make.centerY.equalToSuperview()
    }

    stackView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(goodsImage.snp.trailing).offset(8.0)
      make.trailing.equalToSuperview().inset(16)
    }

    saleTypeView.snp.makeConstraints { make in
      make.width.equalTo(45)
      make.height.equalTo(20)
    }
  }
}

extension GoodsCell {
  /// 명시적으로 호출해야 합니다.
  func updateCell(_ product: ProductModel, isShowTitleLogoView: Bool) {
    goodsLabel.text = product.name
    
    let discount = product.saleType == .onePlusOne ? 2 : 3
    let multiply = product.saleType == .onePlusOne ? 1 : 2
    let unitPrice = Int(product.price / discount * multiply).commaRepresentation
    priceLabel.text = "\(product.price.commaRepresentation)원(개당 \(unitPrice)원)"
    
    saleTypeView.updateStyles(product)
    if isShowTitleLogoView {
      titleLogoView.updateStyles(product)
    }

    if let imageLink = product.imageLink,
       imageLink != "None" {
      goodsImage.kf.setImage(with: URL(string: imageLink), options: [.transition(.fade(0.5))])
    }
  }
}
