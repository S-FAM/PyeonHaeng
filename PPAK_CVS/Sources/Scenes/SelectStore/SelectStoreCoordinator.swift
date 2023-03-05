//
//  SelectStoreCoordinator.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2023/01/28.
//

import UIKit

protocol SelectStorePopDelegate: AnyObject {
  var refreshCVSType: (() -> Void)? { get }
}

final class SelectStoreCoordinator: BaseCoordinator, SelectStorePopDelegate {
  var refreshCVSType: (() -> Void)?

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

  private func bind(_ reactor: SelectStoreViewReactor) {

    // SelectStoreVC -> SettingsVC (Pop)
    reactor.state
      .map { $0.isPopSelectStoreVC }
      .filter { $0 }
      .withUnretained(self)
      .bind { owner, _ in
        owner.navigationController.popViewController(animated: true)
        owner.refreshCVSType?()
      }
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
