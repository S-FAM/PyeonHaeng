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
    backgroundColor = .link // for test
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
