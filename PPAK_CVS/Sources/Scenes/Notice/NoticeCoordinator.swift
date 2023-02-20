//
//  NoticeCoordinator.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2023/02/18.
//

import UIKit

import RxSwift

final class NoticeCoordinator: BaseCoordinator {

  override func start() {
    let reactor = NoticeViewReactor()
    let noticeVC = NoticeViewController()
    noticeVC.coordinator = self
    noticeVC.reactor = reactor
    self.navigationController.pushViewController(noticeVC, animated: true)
    self.bind(reactor)
  }

  private func bind(_ reactor: NoticeViewReactor) {

    // NoticeVC -> SettingVC
    reactor.state
      .map { $0.isPopNoticetVC }
      .filter { $0 }
      .withUnretained(self)
      .bind { owner, _ in
        owner.navigationController.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
  }
}
