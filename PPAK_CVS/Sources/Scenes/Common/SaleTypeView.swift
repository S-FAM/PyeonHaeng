//
//  SaleTypeView.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/11/19.
//

import UIKit

import Then
import SnapKit

final class SaleTypeView: UIView {

  lazy var titleLabel = UILabel().then {
    $0.text = cvsType.rawValue
    $0.textColor = cvsType.fontColor
    $0.font = .systemFont(ofSize: 12, weight: .bold)
  }

  private let cvsType: CVSType

  init(cvsType: CVSType) {
    self.cvsType = cvsType
    super.init(frame: .zero)
    setupStyles()
    setTitle()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setup

  private func setupStyles() {
    backgroundColor = cvsType.bgColor
    layer.cornerRadius = 8
  }

  private func setTitle() {
    addSubview(titleLabel)

    titleLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(12)
      make.top.bottom.equalToSuperview().inset(4)
    }
  }
}

extension SaleTypeView {
  func updateStyles(_ product: ProductModel) {
    titleLabel.text = product.saleType.rawValue
    titleLabel.textColor = product.store.fontColor
    backgroundColor = product.store.bgColor
  }
}
