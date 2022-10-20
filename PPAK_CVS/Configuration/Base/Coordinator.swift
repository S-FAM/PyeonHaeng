import UIKit

protocol Coordinator: AnyObject {

  var navigationController: UINavigationController { get set }
  var childCoordinators: [Coordinator] { get set }
  var parentCoordinator: Coordinator? { get set }

  func start()
  func start(childCoordinator: Coordinator)
  func finish(childCoordinator: Coordinator)
}

extension Coordinator {
  func start(childCoordinator: Coordinator) {
    self.childCoordinators.append(childCoordinator)
    childCoordinator.parentCoordinator = self
    childCoordinator.start()
  }

  func finish(childCoordinator: Coordinator) {
    childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
  }
}
