//
//  NetworkCoordinator.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/11/12.
//

import Foundation

final class NetworkCoordinator: BaseCoordinator {

  override func start() {
    let viewController = NetworkViewController()
    viewController.coordinator = self
    self.navigationController.setViewControllers([viewController], animated: true)
  }
}
