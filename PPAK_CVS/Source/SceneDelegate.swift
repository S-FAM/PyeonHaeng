//
//  SceneDelegate.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/09/12.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let scene = scene as? UIWindowScene else { return }
    let window = UIWindow(windowScene: scene)
    self.window = window

    let navVC = UINavigationController(rootViewController: ViewController())
    window.rootViewController = navVC

    window.makeKeyAndVisible()
  }
}
