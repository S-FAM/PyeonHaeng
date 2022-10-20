import UIKit

protocol Coordinator: AnyObject {

  var navigationController: UINavigationController { get set }
  var childCoordinators: [Coordinator] { get set }
  var parentCoordinator: Coordinator? { get set }

  func start()
  func start(coordinator: Coordinator)
  func finish(childCoordinator: Coordinator)
}

extension Coordinator {
  func start(coordinator: Coordinator) {
    self.childCoordinators.append(coordinator)
    coordinator.parentCoordinator = self
    coordinator.start()
  }

  func finish(childCoordinator: Coordinator) {
    childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
  }
}
