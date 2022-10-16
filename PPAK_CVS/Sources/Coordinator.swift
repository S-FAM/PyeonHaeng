import UIKit

protocol Coordinator: AnyObject {

  var navigationController: UINavigationController { get set }
  var childCoordinators: [Coordinator] { get set }
  var parentCoordinator: Coordinator? { get set }

  func start()
  func start(coordinator: Coordinator)
  func finish(coordinator: Coordinator)
}


extension Coordinator {
  func start(coordinator: Coordinator) {
    childCoordinators.append(coordinator)
    coordinator.parentCoordinator = self
    coordinator.start()
  }
  
  func finish(coordinator: Coordinator) {
    childCoordinators = childCoordinators.filter { $0 !== coordinator }
  }
}
