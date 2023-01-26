import UIKit

import RxSwift
import RxCocoa

final class BookmarkCoordinator: BaseCoordinator {

  override func start() {
    let viewController = BookmarkViewController()
    let viewModel = BookmarkViewModel()
    viewController.coordinator = self
    viewController.viewModel = viewModel
    bind(viewModel)
    self.navigationController.pushViewController(viewController, animated: true)
  }

  func bind(_ viewModel: BookmarkViewModel) {

    // BookmarkVC -> HomeVC
    viewModel.state
      .map { $0.showsHomeVC }
      .filter { $0 }
      .withUnretained(self)
      .bind { $0.0.navigationController.popViewController(animated: true) }
      .disposed(by: disposeBag)

    // BookmarkVC -> SettingVC
    viewModel.state
      .map { $0.showsSettingVC }
      .filter { $0 }
      .withUnretained(self)
      .bind { owner, _ in
        let coordinator = SettingCoordinator(navigationController: owner.navigationController)
        coordinator.start(childCoordinator: owner.self)
      }
      .disposed(by: disposeBag)
  }
}
