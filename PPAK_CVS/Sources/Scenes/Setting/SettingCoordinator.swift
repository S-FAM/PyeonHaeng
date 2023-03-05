//
//  SettingCoordinator.swift
//  PPAK_CVS
//
//  Created by hyeonseok on 2022/12/19.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

final class SettingCoordinator: BaseCoordinator, SelectStorePopDelegate {
  var refreshCVSType: (() -> Void)?

  override func start() {
    let reactor = SettingViewReactor()
    let viewController = SettingViewController()
    viewController.coordinator = self
    viewController.reactor = reactor
    bind(reactor)
    self.navigationController.pushViewController(viewController, animated: true)
  }

  func bind(_ reactor: SettingViewReactor) {

    // NoticeVC로 이동
    reactor.state
      .filter { $0.selectedCell == .notice }
      .withUnretained(self)
      .bind { owner, _ in
        let coordinator = NoticeCoordinator(navigationController: owner.navigationController)
        owner.start(childCoordinator: coordinator)
      }
      .disposed(by: disposeBag)

    reactor.state
      .filter { $0.selectedCell == .selectStore }
      .withUnretained(self)
      .bind { owner, _ in
        let coordinator = SelectStoreCoordinator(owner.navigationController, fromSettings: true)
        coordinator.refreshCVSType = {
          owner.refreshCVSType?()
        }
        owner.start(childCoordinator: coordinator)
      }
      .disposed(by: disposeBag)
  }
}
