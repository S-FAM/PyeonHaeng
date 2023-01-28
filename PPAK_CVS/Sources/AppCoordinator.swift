//
//  AppCoordinator.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/10/17.
//

import UIKit

final class AppCoordinator: BaseCoordinator {

  override func start() {
    self.navigationController.delegate = self

    // == first launch check ==
    let coordinator: Coordinator
//    if FTUXStorage().isAlreadyCome() {
//      coordinator = HomeCoordinator(navigationController: self.navigationController)
//    } else {
//      coordinator = OnboardingCoordinator(navigationController: self.navigationController)
//    }
    coordinator = SelectStoreCoordinator(navigationController: self.navigationController)
    start(childCoordinator: coordinator)
  }

  func switchToHome(coordinator: OnboardingCoordinator) {
    finish(childCoordinator: coordinator)
    start(childCoordinator: HomeCoordinator(navigationController: self.navigationController))
  }
}

// MARK: - Delegates

extension AppCoordinator: UINavigationControllerDelegate {

  func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController,
    animated: Bool
  ) {
    guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) as? BaseViewController,
          let coordinator = fromVC.coordinator
    else { return }

    if navigationController.viewControllers.contains(fromVC) { return }

    // Coordinators must have their own parents except for the `AppCoordinator`.
    assert(coordinator.parentCoordinator != nil)

    coordinator.parentCoordinator?.finish(childCoordinator: coordinator)
  }
}
