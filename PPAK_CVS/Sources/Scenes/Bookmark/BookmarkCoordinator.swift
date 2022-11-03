import UIKit

import RxSwift
import RxCocoa

final class BookmarkCoordinator: BaseCoordinator {

  private let disposeBag = DisposeBag()

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
      .map { $0.showHomeVC }
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
