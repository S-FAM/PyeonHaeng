//
//  BookmarkCoordinator.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/10/08.
//

import UIKit

final class BookmarkCoordinator: Coordinator {

  var navigationController: UINavigationController

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let viewController = BookmarkViewController()
    self.navigationController.setViewControllers([viewController], animated: true)
  }
}
