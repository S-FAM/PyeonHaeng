//
//  AppCoordinator.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/10/17.
//

import UIKit

final class AppCoordinator: BaseCoordinator {

  override func start() {

    // == first launch check ==
    let coordinator: Coordinator
    if FTUXStorage().isAlreadyCome() {
      coordinator = HomeCoordinator(navigationController: self.navigationController)
    } else {
      coordinator = OnboardingCoordinator(navigationController: self.navigationController)
    }

    start(coordinator: coordinator)
  }

  func switchToHome(coordinator: OnboardingCoordinator) {
    finish(coordinator: coordinator)
    start()
  }
}

// MARK: - Delegates

extension AppCoordinator: UINavigationControllerDelegate {

  func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController,
    animated: Bool
  ) {
    guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }

    if navigationController.viewControllers.contains(fromVC) { return }

    if let viewController = fromVC as? BaseViewController,
       let coordinator = viewController.coordinator {
      finish(coordinator: coordinator)
    }
  }
}
