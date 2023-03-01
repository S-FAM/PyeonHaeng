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

  let cvsButton = UIButton().then {
    $0.setImage(CVSType.all.image, for: .normal)
  }

  let filterButton = UIButton().then {
    $0.setImage(UIImage(named: "ic_sort"), for: .normal)
  }

  private let iconContainerView = UIView().then {
    $0.backgroundColor = .clear
  }

  let bookmarkButton = UIButton().then {
    $0.setImage(UIImage(named: "ic_heart_white"), for: .normal)
  }

  let pageControl = EventControl()
  let searchBar = SearchBar()
  let topCurveView = TopCurveView()
  private let appIconImageView = UIImageView(image: UIImage(named: "ic_home_appIcon"))

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
    [
      topCurveView,
      pageControl,
      searchBar,
      filterButton,
      iconContainerView
    ]
      .forEach { self.addSubview($0) }

    [
      bookmarkButton,
      cvsButton,
      appIconImageView
    ]
      .forEach { iconContainerView.addSubview($0) }
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
      make.leading.equalToSuperview().inset(40)
      make.trailing.equalTo(filterButton.snp.leading).offset(-13)
      make.height.equalTo(50)
    }

    filterButton.snp.makeConstraints { make in
      make.centerY.equalTo(searchBar)
      make.trailing.equalToSuperview().inset(16)
      make.width.height.equalTo(44)
    }

    iconContainerView.snp.makeConstraints { make in
      make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
      make.bottom.equalTo(pageControl.snp.top)
    }

    cvsButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().inset(40)
      make.centerY.equalToSuperview()
      make.width.height.equalTo(44)
    }

    bookmarkButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalTo(cvsButton.snp.leading).offset(-20)
      make.width.height.equalTo(44)
    }

    appIconImageView.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(40)
      make.centerY.equalToSuperview()
    }
  }
}
