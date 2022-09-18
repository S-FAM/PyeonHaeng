//
//  ViewController.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/09/12.
//

import UIKit
import SnapKit
import Then

final class HomeViewController: BaseViewController {
  // MARK: - Properties
  lazy var pageControl = PageControl().then {
    $0.delegate = self
  }

  let topCurveView = TopCurveView()
  let bottomCurveView = BottomCurveView()
  let searchBar = SearchBar()

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: - Setup
  override func setupLayouts() {
    [ topCurveView, bottomCurveView, pageControl, searchBar ]
      .forEach { view.addSubview($0) }
  }

  override func setupStyles() {
    view.backgroundColor = .blue
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
    print(index)
  }
}
