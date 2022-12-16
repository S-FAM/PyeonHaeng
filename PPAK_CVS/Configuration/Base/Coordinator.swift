import UIKit

protocol Coordinator: AnyObject {

  var navigationController: UINavigationController { get set }
  var childCoordinators: [any Coordinator] { get set }
  var parentCoordinator: Coordinator? { get set }

  func start()
  func start(childCoordinator: some Coordinator)
  func finish(childCoordinator: some Coordinator)
}

extension Coordinator {
  func start(childCoordinator: some Coordinator) {
    self.childCoordinators.append(childCoordinator)
    childCoordinator.parentCoordinator = self
    childCoordinator.start()
  }

  func finish(childCoordinator: some Coordinator) {
    childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
  }
}
