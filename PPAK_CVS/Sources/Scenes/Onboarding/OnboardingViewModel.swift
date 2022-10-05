//
//  OnboardingViewModel.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/10/05.
//

import UIKit

final class OnboardingViewModel {
  
  func navigateToHomeVC(_ navigationController: UINavigationController) {
    FTUXStorage().saveFTUXStatus()

    let coordinator = OnboardingCoordinator(navigationController: navigationController)
    coordinator.navigateToHomeVC()
  }
}
