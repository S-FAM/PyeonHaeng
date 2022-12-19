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
  
  private let disposeBag = DisposeBag()

  override func start() {
    let viewModel = SettingViewModel()
    let viewController = SettingViewController()
    viewController.coordinator = self
    viewController.viewModel = viewModel
    bind(viewModel)
    self.navigationController.pushViewControllers([viewController], animated: true)
  }

  func bind(_ viewModel: SettingViewModel) {}
}
