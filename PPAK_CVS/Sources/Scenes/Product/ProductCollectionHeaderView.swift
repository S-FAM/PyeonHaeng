//
//  ProductCollectionHeaderView.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/10/10.
//

import UIKit

import Kingfisher
import RxSwift
import RxCocoa
import SnapKit
import Then

final class ProductCollectionHeaderView: UICollectionReusableView, Viewable {
  static let id = "ProductCollectionHeaderView"

  var disposeBag = DisposeBag()

  private let productImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }

  private let nameLabel = UILabel().then {
    $0.font = Font.nameLabel
    $0.text = "코카)씨그램피치탄산수350ML"
  }

  private let priceLabel = UILabel().then {
    $0.font = Font.priceLabel
    $0.text = "1,500원"
  }

  private let previousHistoryLabel = UILabel().then {
    $0.font = Font.previousHistoryLabel
    $0.text = "이전 행사 내역"
    $0.textColor = .white
  }

  private let wholeStackView = UIStackView().then {
    $0.alignment = .center
    $0.distribution = .fill
    $0.axis = .vertical
    $0.spacing = 10
  }

  private let curveView = BottomCurveView().then {
    $0.backgroundColor = .systemPurple
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayouts()
    setupConstraints()
    setupStyles()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - setup

extension ProductCollectionHeaderView {
  private func setupLayouts() {

    // == views ==
    [wholeStackView, curveView].forEach {
      addSubview($0)
    }

    // == stackViews ==
    [productImageView, nameLabel, priceLabel].forEach {
      wholeStackView.addArrangedSubview($0)
    }

    // == curveView ==
    curveView.addSubview(previousHistoryLabel)
  }

  private func setupConstraints() {
    wholeStackView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(Inset.stackViewTop)
    }

    curveView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(wholeStackView.snp.bottom).inset(Inset.curveView)
    }

    productImageView.snp.makeConstraints { make in
      make.width.height.equalTo(240)
    }

    previousHistoryLabel.snp.makeConstraints { make in
      make.bottom.trailing.equalToSuperview().inset(Inset.previousHistoryLabel)
    }

    wholeStackView.setCustomSpacing(16, after: productImageView)
  }

  private func setupStyles() {
    backgroundColor = .systemBackground
  }

  func bind(viewModel: ProductHeaderViewViewModel) {

  }

  func configureUI(with model: ProductModel) {
    let discount = model.saleType == .onePlusOne ? 2 : 3
    let multiply = model.saleType == .onePlusOne ? 1 : 2

    let unitPrice = Int(model.price / discount * multiply).commaRepresentation

    nameLabel.text = model.name
    priceLabel.text = "\(model.price.commaRepresentation)원(개당 \(unitPrice)원)"

    productImageView.kf.setImage(with: URL(string: model.imageLink ?? ""))

    curveView.backgroundColor = model.store.bgColor
  }
}

// MARK: - Constants

extension ProductCollectionHeaderView {

  private enum Font {
    static let nameLabel = UIFont.appFont(family: .bold, size: 18)
    static let priceLabel = UIFont.appFont(family: .regular, size: 15)
    static let previousHistoryLabel = UIFont.appFont(family: .bold, size: 14)
  }

  private enum Inset {

    static let shareButton = 5

    static let previousHistoryLabel = 10

    static let curveView = 10

    static let stackViewTop = 25
  }
}
