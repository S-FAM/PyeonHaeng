import UIKit

import RxSwift
import RxCocoa

final class HomeCoordinator: BaseCoordinator {

  private let disposeBag = DisposeBag()

  override func start() {
    let viewModel = HomeViewModel()
    let viewController = HomeViewController()
    viewController.viewModel = viewModel
    bind(viewModel)
    self.navigationController.setViewControllers([viewController], animated: true)
  }

  func bind(_ viewModel: HomeViewModel) {

    // Home VC -> Bookmark VC
    viewModel.state
      .map { $0.showBookmarkVC }
      .distinctUntilChanged()
      .filter { $0 }
      .bind(onNext: { [unowned self] _ in
        let coordinator = BookmarkCoordinator(navigationController: self.navigationController)
        coordinator.start(childCoordinator: coordinator)
      })
      .disposed(by: disposeBag)
  }
}
