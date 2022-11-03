import UIKit

final class HomeCoordinator: BaseCoordinator {

  override func start() {
    let viewModel = HomeViewModel()
    let viewController = HomeViewController()
    viewController.coordinator = self
    viewController.viewModel = viewModel
    self.navigationController.setViewControllers([viewController], animated: true)
  }
}
