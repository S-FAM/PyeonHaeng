//
//  ViewController.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/09/12.
//

import UIKit
import SnapKit

final class HomeViewController: BaseViewController {
  // MARK: - Properties
  let topCurveView = TopCurveView()
  let bottomCurveView = BottomCurveView()

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Setup
  override func setupLayouts() {
    [ topCurveView, bottomCurveView ]
      .forEach { view.addSubview($0) }
  }

  override func setupStyles() {
    view.backgroundColor = .white
    topCurveView.backgroundColor = .systemRed
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
  }
}
