//
//  SelectStoreCoordinator.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2023/01/28.
//

import Foundation

final class SelectStoreCoordinator: BaseCoordinator {
  
  override func start() {
    let reactor = SelectStoreViewReactor()
    let selectStoreVC = SelectStoreViewController()
    selectStoreVC.coordinator = self
    selectStoreVC.reactor = reactor
    self.navigationController.setViewControllers([selectStoreVC], animated: true)
    
    self.bind(reactor)
  }
  
  private func bind(_ reactor: SelectStoreViewReactor) {

    // 홈 화면으로 이동하기
    reactor.state.map { $0.isPushHomeVC }
      .distinctUntilChanged()
      .bind { [weak self] isPush in
        guard let self = self,
              let parentCoordinator = self.parentCoordinator as? AppCoordinator else { return }

        if isPush {
          parentCoordinator.switchToHome(coordinator: self)
        }
      }
      .disposed(by: disposeBag)
  }
}
