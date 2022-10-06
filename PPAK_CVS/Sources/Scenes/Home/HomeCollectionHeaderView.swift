//
//  HomeCollectionHeaderView.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/09/25.
//

import UIKit

import SnapKit
import Then

final class HomeCollectionHeaderView: UICollectionReusableView {

  // MAKR: - Properties
  static let id = "HomeCollectionViewHeader"

  lazy var pageControl = PageControl()
  lazy var topCurveView = TopCurveView()
  lazy var searchBar = SearchBar()

  lazy var cvsButton = UIButton().then {
    $0.setImage(UIImage(named: "logo_all"), for: .normal)
  }

  lazy var filterButton = UIButton().then {
    $0.setImage(UIImage(named: "filter"), for: .normal)
  }

  lazy var logoLabel = UILabel().then {
    $0.text = "logo"
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 32.0, weight: .heavy)
  }

  lazy var bookmarkButton = UIButton().then {
    let image = UIImage(systemName: "heart.circle.fill")?.applyingSymbolConfiguration(.init(pointSize: 40))
    $0.setImage(image, for: .normal)
    $0.tintColor = .white
  }

  // MARK: - Init

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

  private func setupStyles() {
    topCurveView.backgroundColor = .blue
  }

  private func setupLayouts() {
    [topCurveView, pageControl, searchBar, filterButton, logoLabel, cvsButton, bookmarkButton]
      .forEach { self.addSubview($0) }
  }

  private func setupConstraints() {
    topCurveView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    pageControl.snp.makeConstraints { make in
      make.centerY.equalToSuperview().offset(16)
      make.leading.trailing.equalToSuperview().inset(40)
      make.height.equalTo(65)
    }

    searchBar.snp.makeConstraints { make in
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview().inset(32)
      make.trailing.equalTo(filterButton.snp.leading).offset(-16)
      make.height.equalTo(50)
    }

    filterButton.snp.makeConstraints { make in
      make.centerY.equalTo(searchBar)
      make.trailing.equalToSuperview().inset(32)
      make.width.height.equalTo(30)
    }

    logoLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.safeAreaLayoutGuide).inset(8)
    }

    cvsButton.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide).inset(8)
      make.leading.equalToSuperview().inset(16)
      make.width.height.equalTo(40)
    }

    bookmarkButton.snp.makeConstraints { make in
      make.centerY.equalTo(cvsButton)
      make.trailing.equalToSuperview().inset(16)
    }
  }
}
