//
//  LoadingCell.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/11/27.
//

import UIKit

import SnapKit
import Then

final class LoadingCell: UICollectionViewCell {
  
  // MARK: - Properties
  
  private let indicator = UIActivityIndicatorView().then {
    $0.color = .gray
  }
  
  // MARK: - LifeCycle
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    setupStyles()
    setupLayout()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  
  private func setupLayout() {
    contentView.addSubview(indicator)
  }
  
  private func setupConstraints() {
    indicator.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
  
  private func setupStyles() {
    indicator.startAnimating()
  }
}
