//
//  TitleLogoView.swift
//  PPAK_CVS
//
//  Created by hyeonseok on 2022/10/03.
//

import UIKit

import SnapKit
import Then

final class TitleLogoView: UIView {

  // MARK: - Properties

  lazy var titleLabel = UILabel().then {
    $0.text = cvsType.rawValue
    $0.textColor = cvsType.fontColor
    $0.font = .appFont(family: .bold, size: 12)
  }

  private let cvsType: CVSType
  private var isInitialized: Bool = false

  // MARK: - Initializer

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
    layer.cornerRadius = 10
  }

  private func setTitle() {
    addSubview(titleLabel)

    titleLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}

extension TitleLogoView {
  func updateStyles(_ product: ProductModel) {
    titleLabel.text = product.store.rawValue
    titleLabel.textColor = product.store.fontColor
    backgroundColor = product.store.bgColor

    let width: Int

    switch product.store {
    case .eMart, .miniStop, .sevenEleven:
      width = 80
    default:
      width = 50
    }

    if isInitialized {
      self.snp.updateConstraints { make in
        make.height.equalTo(20)
        make.width.equalTo(width)
      }
    } else {
      self.snp.makeConstraints { make in
        make.height.equalTo(20)
        make.width.equalTo(width)
      }
    }

    isInitialized = true
  }
}
