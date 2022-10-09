//
//  ProductViewController.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/10/09.
//

import UIKit

import SnapKit
import Then

final class ProductViewController: BaseViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func setupLayouts() {
    super.setupLayouts()

    // navigation bar
    navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "heart"),
      style: .plain,
      target: self,
      action: nil
    )

    navigationItem.titleView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 50)).then {
      $0.backgroundColor = .systemGray
    }
  }
}
