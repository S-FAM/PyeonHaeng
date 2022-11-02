//
//  BookmarkCoordinator.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/10/08.
//

import UIKit

final class BookmarkCoordinator: BaseCoordinator {

  override func start() {
    let viewController = BookmarkViewController()
    viewController.coordinator = self
    self.navigationController.setViewControllers([viewController], animated: true)
  }
}
