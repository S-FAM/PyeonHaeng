import UIKit

import class RxSwift.DisposeBag

class BaseCoordinator: NSObject, Coordinator {

  let disposeBag = DisposeBag()

  var childCoordinators: [any Coordinator] = []
  var navigationController: UINavigationController
  var parentCoordinator: Coordinator?

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    fatalError("start() method must be implemented")
  }
}
