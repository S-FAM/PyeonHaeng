//
//  SelectStoreCoordinator.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2023/01/28.
//

import UIKit

final class SelectStoreCoordinator: BaseCoordinator {
  
  private let fromSettings: Bool
  
  init(_ navigationController: UINavigationController, fromSettings: Bool) {
    self.fromSettings = fromSettings
    super.init(navigationController: navigationController)
  }
  
  override func start() {
    let reactor = SelectStoreViewReactor()
    let selectStoreVC = SelectStoreViewController(fromSettings: self.fromSettings)
    selectStoreVC.coordinator = self
    selectStoreVC.reactor = reactor
    self.navigationController.pushViewController(selectStoreVC, animated: true)
    
    self.bind(reactor)
  }
  
  func bind(_ reactor: SelectStoreViewReactor) {
    
    // SelectStoreVC -> SettingsVC (Pop)
    reactor.state
      .map { $0.isPopSelectStoreVC }
      .filter { $0 }
      .withUnretained(self)
      .bind { $0.0.navigationController.popViewController(animated: true) }
      .disposed(by: disposeBag)

    // SelectStroeVC -> HomeVC (Push)
    reactor.state
      .map { $0.isPushHomeVC }
      .filter { $0 }
      .distinctUntilChanged()
      .withUnretained(self)
      .bind { owner, _ in
        let coordinator = HomeCoordinator(navigationController: owner.navigationController)
        owner.start(childCoordinator: coordinator)
      }
      .disposed(by: disposeBag)
  }
}
