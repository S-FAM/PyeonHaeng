//
//  NetworkCheck.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/11/12.
//

import Network
import UIKit

final class NetworkCheck {
  static let shared = NetworkCheck()
  private let queue = DispatchQueue.global()
  private let monitor: NWPathMonitor
  public private(set) var isConnected: Bool = false
  public private(set) var topVCIsNetworkVC: Bool = false

  // monotior 초기화
  private init() {
    self.monitor = NWPathMonitor()
  }

  // Network Monitoring 시작
  public func startMonitoring() {
    self.monitor.start(queue: queue)
    self.monitor.pathUpdateHandler = { [weak self] path in
      guard let self = self else { return }

      self.isConnected = path.status == .satisfied

      if self.isConnected {
        print(#function, "연결됨!")

        if self.topVCIsNetworkVC {
          DispatchQueue.main.async {
            guard let topVC = UIApplication.topViewController() else { return }
            topVC.dismiss(animated: true)
            self.topVCIsNetworkVC = false
          }
        }
      } else {
        print(#function, "연결안됨!")

        if self.topVCIsNetworkVC == false {
          DispatchQueue.main.async {
            let networkViewController = NetworkViewController()
            networkViewController.modalPresentationStyle = .overFullScreen
            guard let topVC = UIApplication.topViewController() else { return }
            topVC.present(networkViewController, animated: true)
            self.topVCIsNetworkVC = true
          }
        }
      }
    }
  }
}
