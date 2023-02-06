//
//  OnboardingCoordinator.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/09/24.
//

import UIKit

import RxSwift

final class OnboardingCoordinator: BaseCoordinator {

  override func start() {
    let reactor = OnboardingViewReactor()
    let onboardingVC = OnboardingViewController()
    onboardingVC.coordinator = self
    onboardingVC.reactor = reactor
    self.navigationController.setViewControllers([onboardingVC], animated: true)

    self.bind(reactor)
  }

  private func bind(_ reactor: OnboardingViewReactor) {

    // OnboardingVC -> SelectStoreVC
    reactor.state
      .map { $0.isPushSelectStoreVC }
      .filter { $0 }
      .distinctUntilChanged()
      .withUnretained(self)
      .bind { owner, _ in
        FTUXStorage().saveFTUXStatus()
        let coordinator = SelectStoreCoordinator(owner.navigationController, fromSettings: false)
        owner.start(childCoordinator: coordinator)
      }
      .disposed(by: disposeBag)
  }
}
