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
    $0.setImage(CVSType.all.image, for: .normal)
  }

  lazy var filterButton = UIButton().then {
    $0.setImage(UIImage(named: "ic_sort"), for: .normal)
  }

  lazy var bookmarkButton = UIButton().then {
    let image = UIImage(systemName: "heart.circle.fill")?.applyingSymbolConfiguration(.init(pointSize: 44))
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
    topCurveView.backgroundColor = CVSType.all.bgColor
    pageControl.focusedView.backgroundColor = CVSType.all.bgColor
  }

  private func setupLayouts() {
    [topCurveView, pageControl, searchBar, filterButton, cvsButton, bookmarkButton]
      .forEach { self.addSubview($0) }
  }

  private func setupConstraints() {
    topCurveView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    pageControl.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(40)
      make.bottom.equalToSuperview().inset(110)
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

    cvsButton.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide).inset(23)
      make.trailing.equalToSuperview().inset(40)
      make.width.height.equalTo(44)
    }

    bookmarkButton.snp.makeConstraints { make in
      make.centerY.equalTo(cvsButton)
      make.trailing.equalTo(cvsButton.snp.leading).offset(-20)
    }
  }
}
