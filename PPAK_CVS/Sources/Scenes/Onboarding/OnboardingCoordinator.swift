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

    // 편의점 선택 화면으로 이동하기
    reactor.state.map { $0.isPushSelectStoreVC }
      .distinctUntilChanged()
      .bind { [weak self] isPush in
        guard let self = self,
              let parentCoordinator = self.parentCoordinator as? AppCoordinator else { return }

        if isPush {
          FTUXStorage().saveFTUXStatus()
          parentCoordinator.switchToSelectStore(coordinator: self)
        }
      }
      .disposed(by: disposeBag)
  }
}
