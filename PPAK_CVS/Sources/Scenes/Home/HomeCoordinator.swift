import UIKit

import RxSwift
import RxCocoa

final class HomeCoordinator: BaseCoordinator {

  override func start() {
    let reactor = HomeViewReactor()
    let viewController = HomeViewController()
    viewController.coordinator = self
    viewController.reactor = reactor
    bind(reactor)
    self.navigationController.setViewControllers([viewController], animated: true)
  }

  func bind(_ reactor: HomeViewReactor) {

    // Bookmark VC
    reactor.state
      .map { $0.showsBookmarkVC }
      .filter { $0 }
      .withUnretained(self)
      .bind { owner, _ in
        let coordinator = BookmarkCoordinator(navigationController: owner.navigationController)
        owner.start(childCoordinator: coordinator)
      }
      .disposed(by: disposeBag)

    // ProductVC
    reactor.state
      .map { $0.showsProductVC }
      .filter { $0.0 }
      .withUnretained(self)
      .bind { owner, product in
        let coordinator = ProductCoordinator(owner.navigationController, model: product.1)
        owner.start(childCoordinator: coordinator)
      }
      .disposed(by: disposeBag)

    // SettingVC
    reactor.state
      .map { $0.showsSettingVC }
      .filter { $0 }
      .withUnretained(self)
      .bind { owner, _ in
        let coordinator = SettingCoordinator(navigationController: owner.navigationController)
        coordinator.start(childCoordinator: coordinator)
      }
      .disposed(by: disposeBag)
  }
}
