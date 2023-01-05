//
//  SettingCoordinator.swift
//  PPAK_CVS
//
//  Created by hyeonseok on 2022/12/19.
//

import UIKit

import RxSwift
import RxCocoa

final class SettingCoordinator: BaseCoordinator {

  override func start() {
    let viewModel = SettingViewModel()
    let viewController = SettingViewController()
    viewController.coordinator = self
    viewController.viewModel = viewModel
    bind(viewModel)
    self.navigationController.pushViewController(viewController, animated: true)
  }

  func bind(_ viewModel: SettingViewModel) {}
}
