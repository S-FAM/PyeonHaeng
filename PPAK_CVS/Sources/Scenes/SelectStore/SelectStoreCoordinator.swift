//
//  SelectStoreCoordinator.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2023/01/28.
//

import Foundation

final class SelectStoreCoordinator: BaseCoordinator {
  
  override func start() {
    let selectStoreVC = SelectStoreViewController()
    selectStoreVC.coordinator = self
    self.navigationController.setViewControllers([selectStoreVC], animated: true)
  }
}
