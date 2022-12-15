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

  private var topVC: UIViewController? {
    let scenes = UIApplication.shared.connectedScenes
    let windowScene = scenes.first as? UIWindowScene
    let window = windowScene?.windows.first
    return window?.rootViewController
  }

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

      if self.isConnected && self.topVCIsNetworkVC {
        // 네트워크와 연결됨, 제일 위에 뷰가 NetworkVC임. -> NetworkVC 사라지기
        self.dismissNetworkVC()
      }

      if self.isConnected == false && self.topVCIsNetworkVC == false {
        // 네트워크와 연결안됨, 제일 위에 뷰가 NetworkVC가 아님. -> NetworkVC 보여주기
        self.presentNetworkVC()
      }
    }
  }

  private func presentNetworkVC() {
    DispatchQueue.main.async {
      let networkViewController = NetworkViewController()
      networkViewController.modalPresentationStyle = .overFullScreen

      guard let topVC = self.topVC else { return }
      topVC.present(networkViewController, animated: true)
      self.topVCIsNetworkVC = true
    }
  }

  private func dismissNetworkVC() {
    DispatchQueue.main.async {
      guard let topVC = self.topVC else { return }
      topVC.dismiss(animated: true)
      self.topVCIsNetworkVC = false
    }
  }
}
