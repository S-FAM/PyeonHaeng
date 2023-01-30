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

  func bind(_ reactor: SettingViewReactor) {}
}
