//
//  ProductCoordinator.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/10/09.
//

import UIKit

final class ProductCoordinator: BaseCoordinator {

  override func start() {
    let viewController = ProductViewController()
    let viewModel = ProductViewModel()
    viewController.coordinator = self
    viewController.viewModel = viewModel
    self.navigationController.pushViewController(viewController, animated: true)
  }
}
