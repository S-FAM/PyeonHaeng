//
//  OnboardingCoordinator.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/09/24.
//

import UIKit

import RxSwift

final class OnboardingCoordinator: BaseCoordinator {

  private let disposeBag = DisposeBag()

  override func start() {
    let onboardingViewModel = OnboardingViewModel()
    let onboardingVC = OnboardingViewController()
    onboardingVC.coordinator = self
    onboardingVC.viewModel = onboardingViewModel
    self.navigationController.setViewControllers([onboardingVC], animated: true)

    self.bind(onboardingViewModel)
  }

  private func bind(_ viewModel: OnboardingViewModel) {

    // 홈 화면으로 이동하기
    viewModel.state.map { $0.isPushHomeVC }
      .distinctUntilChanged()
      .bind { [weak self] isPush in
        guard let self = self,
              let parentCoordinator = self.parentCoordinator as? AppCoordinator else { return }

        if isPush {
          FTUXStorage().saveFTUXStatus()
          parentCoordinator.switchToHome(coordinator: self)
        }
      }
      .disposed(by: disposeBag)
  }
}
