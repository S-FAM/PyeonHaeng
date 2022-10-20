import UIKit

class BaseCoordinator: NSObject, Coordinator {
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController
  var parentCoordinator: Coordinator?

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    fatalError("start() method must be implemented")
  }
}
