//
//  ProductCollectionHeaderView.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/10/10.
//

import UIKit

final class ProductCollectionHeaderView: UICollectionReusableView {
  static let id = "ProductCollectionHeaderView"

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

  }

  private func setupConstraints() {

  }

  private func setupStyles() {
    
  }
}

// MARK: - Constants

extension ProductCollectionHeaderView {

  private enum Font {
    static let nameLabel = UIFont.boldSystemFont(ofSize: 20)
    static let priceLabel = UIFont.systemFont(ofSize: 20, weight: .medium)
    static let priceDescriptionLabel = UIFont.systemFont(ofSize: 16, weight: .regular)

    static let previousHistoryLabel = UIFont.boldSystemFont(ofSize: 16)
  }

  private enum Inset {

    static let shareButton = 5

    static let previousHistoryLabel = 10

    static let curveView = 10

    enum StackView {
      static let top = 10
    }
  }
}
