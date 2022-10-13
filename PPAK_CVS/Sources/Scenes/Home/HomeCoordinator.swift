import UIKit

final class HomeCoordinator: Coordinator {

  var navigationController: UINavigationController

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let viewController = HomeViewController()
    self.navigationController.setViewControllers([viewController], animated: true)
  }
}
