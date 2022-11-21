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
    $0.font = .systemFont(ofSize: 16.0, weight: .bold)
  }

  private let priceLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 14.0, weight: .light)
  }

  private let descriptionLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 12.0, weight: .light)
  }

  private let goodsImage = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }

  private lazy var stackView = UIStackView().then { stackView in
    let horiStack = UIStackView(arrangedSubviews: [priceLabel, descriptionLabel])
    horiStack.axis = .horizontal
    horiStack.spacing = 2.0
    [goodsLabel, horiStack, saleTypeView].forEach {
      stackView.addArrangedSubview($0)
    }
      stackView.axis = .vertical
      stackView.spacing = 4.0
      stackView.alignment = .leading
  }

  private let titleLogoView = TitleLogoView(cvsType: .all)
  private let saleTypeView = SaleTypeView(cvsType: .all)

  // MARK: - LifeCycle

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
      make.centerY.equalTo(containerView.snp.top)
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

extension GoodsCell {
  /// 명시적으로 호출해야 합니다.
  func updateCell(_ product: ProductModel) {
    goodsLabel.text = product.name
    priceLabel.text = "\(product.price)원"
    saleTypeView.updateStyles(product)
    titleLogoView.updateStyles(product)

    goodsImage.kf.setImage(
      with: URL(string: product.imageLink ?? ""),
      options: [
        .transition(.fade(0.5))
      ]
    )
  }
}
