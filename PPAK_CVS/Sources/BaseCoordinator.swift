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

extension BaseCoordinator: UINavigationControllerDelegate {

  func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController,
    animated: Bool
  ) {
    guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }

    if navigationController.viewControllers.contains(fromVC) { return }

    if let viewController = fromVC as? BaseViewController,
       let coordinator = viewController.coordinator {
      finish(coordinator: coordinator)
    }
  }
}
