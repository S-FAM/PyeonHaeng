import UIKit

final class HomeCoordinator: BaseCoordinator {

  override func start() {
    let viewController = HomeViewController()
    self.navigationController.setViewControllers([viewController], animated: true)
  }
}
