//
//  ProductCoordinator.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/10/09.
//

import UIKit

final class ProductCoordinator: Coordinator {

  var navigationController: UINavigationController

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let viewController = ProductViewController()
    self.navigationController.pushViewController(viewController, animated: true)
  }
}
