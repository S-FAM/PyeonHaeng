//
//  NetworkViewController.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/11/12.
//

import UIKit

class NetworkViewController: BaseViewController {

  // MARK: - Properties

  private let alertController = UIAlertController(
    title: Strings.Network.alertTitle,
    message: Strings.Network.alertMessage,
    preferredStyle: .alert
  )

  private let endAction = UIAlertAction(
    title: Strings.Network.alertEndAction,
    style: .destructive
  ) { _ in
    // 앱 종료하기
    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      exit(0)
    }
  }

  private let confirmAction = UIAlertAction(
    title: Strings.Network.alertConfirmAction,
    style: .default
  ) { _ in
    // 앱 설정 보여주기
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
    }
  }

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    self.alertController.addAction(self.endAction)
    self.alertController.addAction(self.confirmAction)
    self.present(self.alertController, animated: true, completion: nil)
  }

  override func setupStyles() {
    self.view.backgroundColor = .black
  }
}
