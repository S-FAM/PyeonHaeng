import UIKit

class BaseCoordinator: NSObject, Coordinator {
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
