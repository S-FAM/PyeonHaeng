import UIKit

import RxSwift
import RxCocoa

final class HomeCoordinator: BaseCoordinator {

  override func start() {
    let viewModel = HomeViewModel()
    let viewController = HomeViewController()
    viewController.coordinator = self
    viewController.viewModel = viewModel
    bind(viewModel)
    self.navigationController.setViewControllers([viewController], animated: true)
  }

  func bind(_ viewModel: HomeViewModel) {

    // Bookmark VC
    viewModel.state
      .map { $0.showBookmarkVC }
      .filter { $0 }
      .withUnretained(self)
      .bind { owner, _ in
        let coordinator = BookmarkCoordinator(navigationController: owner.navigationController)
        owner.start(childCoordinator: coordinator)
      }
      .disposed(by: disposeBag)
  }
}
