//
//  SceneDelegate.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/09/12.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var coordinator: Coordinator?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let scene = scene as? UIWindowScene else { return }
    let window = UIWindow(windowScene: scene)
    self.window = window

    let navVC = UINavigationController()

    /// 처음 들어왔으면 false, 아니면 true
    let isAlreadyCome = FTUXStorage().isAlreadyCome()
    if isAlreadyCome {
      coordinator = HomeCoordinator(navigationController: navVC)
    } else {
      coordinator = OnboardingCoordinator(navigationController: navVC)
    }

    self.coordinator?.start()

    window.rootViewController = navVC
    window.makeKeyAndVisible()
  }
}
