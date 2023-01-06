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
      .bind(onNext: { [unowned self] _ in
        self.toHomeVC()
      })
      .disposed(by: disposeBag)
  }

  func toHomeVC() {
    self.navigationController.popViewController(animated: true)
  }
}
