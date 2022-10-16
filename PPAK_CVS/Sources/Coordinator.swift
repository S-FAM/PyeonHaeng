import UIKit

protocol Coordinator {

  var navigationController: UINavigationController { get set }
  var childCoordinators: [Coordinator] { get set }
  var parentCoordinator: Coordinator? { get set }

  func start()
  func start(coordinator: Coordinator)
  func finish(coordinator: Coordinator)
}
