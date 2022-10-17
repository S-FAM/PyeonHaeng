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

  func switchToMain(coordinator: OnboardingCoordinator) {
    finish(coordinator: coordinator)
    start()
  }
}
