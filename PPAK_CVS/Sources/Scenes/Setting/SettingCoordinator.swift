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

final class SettingCoordinator: BaseCoordinator {

  override func start() {
    let reactor = SettingViewReactor()
    let viewController = SettingViewController()
    viewController.coordinator = self
    viewController.reactor = reactor
    bind(reactor)
    self.navigationController.pushViewController(viewController, animated: true)
  }

  func bind(_ reactor: SettingViewReactor) {

    // NoticeVC로 이동처리
    reactor.state
      .map { $0.showNoticeVC }
      .filter { $0 }
      .withUnretained(self)
      .bind { owner, _ in
        let coordinator = NoticeCoordinator(navigationController: owner.navigationController)
        owner.start(childCoordinator: coordinator)
      }
      .disposed(by: disposeBag)
  }
}
