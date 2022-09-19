//
//  HomeViewController.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/09/12.
//

import UIKit

import SnapKit
import Then

final class HomeViewController: BaseViewController {

  // MARK: - Properties

  private lazy var pageControl = PageControl().then {
    $0.delegate = self
  }

  private let topCurveView = TopCurveView()
  private let bottomCurveView = BottomCurveView()
  private let searchBar = SearchBar()

  // MARK: - LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Setup

  override func setupLayouts() {
    [topCurveView, bottomCurveView, pageControl, searchBar]
      .forEach { view.addSubview($0) }
  }

  override func setupStyles() {
    view.backgroundColor = .systemGray
    topCurveView.backgroundColor = .white
    bottomCurveView.backgroundColor = .systemRed
  }

  override func setupConstraints() {
    topCurveView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.height.equalTo(400)
    }

    bottomCurveView.snp.makeConstraints { make in
      make.bottom.leading.trailing.equalToSuperview()
      make.height.equalTo(400)
    }

    pageControl.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(40)
      make.height.equalTo(70)
    }

    searchBar.snp.makeConstraints { make in
      make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(40)
      make.height.equalTo(50)
    }
  }
}

extension HomeViewController: PageControlDelegate {
  func didChangedSelectedIndex(index: Int) {
    // TODO: All 1+1, 2+1 settings
    // FIXME: Hello
  }
}
