import UIKit

import RxSwift
import RxCocoa

final class BookmarkCoordinator: BaseCoordinator {

  // MARK: - Properties

  private let cvsType: CVSType

  // MARK: - Init

  init(_ navigationController: UINavigationController, cvsType: CVSType) {
    self.cvsType = cvsType
    super.init(navigationController: navigationController)
  }

  override func start() {
    let viewController = BookmarkViewController()
    let reactor = BookmarkViewReactor()
    viewController.coordinator = self
    viewController.reactor = reactor
    bind(reactor)
    self.navigationController.pushViewController(viewController, animated: true)
  }

  func bind(_ reactor: BookmarkViewReactor) {
    reactor.initialState.currentCVS = self.cvsType

    // BookmarkVC -> HomeVC
    reactor.state
      .map { $0.showsHomeVC }
      .filter { $0 }
      .withUnretained(self)
      .bind { $0.0.navigationController.popViewController(animated: true) }
      .disposed(by: disposeBag)

    // BookmarkVC -> SettingVC
    reactor.state
      .map { $0.showsSettingVC }
      .filter { $0 }
      .withUnretained(self)
      .bind { owner, _ in
        let coordinator = SettingCoordinator(navigationController: owner.navigationController)
        owner.start(childCoordinator: coordinator)
      }
      .disposed(by: disposeBag)
  }
}
