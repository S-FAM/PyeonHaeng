//
//  OnboardingCoordinator.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/09/24.
//

import UIKit

import RxSwift

final class OnboardingCoordinator: Coordinator {

  private var disposeBag = DisposeBag()

  var navigationController: UINavigationController

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let onboardingViewModel: OnboardingViewModel = OnboardingViewModel()
    let onboardingVC = OnboardingViewController(viewModel: onboardingViewModel)
    self.navigationController.setViewControllers([onboardingVC], animated: true)

    self.bind(onboardingViewModel)
  }

  private func bind(_ viewModel: OnboardingViewModel) {

    // 홈 화면으로 이동하기
    viewModel.output.navigateToHomeVC
      .subscribe { [weak self] _ in
        guard let self = self else { return }
        let coordinator = HomeCoordinator(navigationController: self.navigationController)
        coordinator.start()
      }
      .disposed(by: disposeBag)
  }
}
