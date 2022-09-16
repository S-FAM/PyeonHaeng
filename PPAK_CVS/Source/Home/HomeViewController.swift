//
//  ViewController.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/09/12.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
  // MARK: - Properties
  let topCurveView = TopCurveView()
  let bottomCurveView = BottomCurveView()

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }

  // MARK: - Helpers
  private func configureUI() {
    view.backgroundColor = .white
    navigationController?.navigationBar.isHidden = true

    [ topCurveView, bottomCurveView ]
      .forEach { view.addSubview($0) }

    bottomCurveView.backgroundColor = .black

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
