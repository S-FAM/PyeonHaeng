//
//  NetworkCheck.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/11/12.
//

import Foundation
import Network

final class NetworkCheck {
  static let shared = NetworkCheck()
  private let queue = DispatchQueue.global()
  private let monitor: NWPathMonitor
  public private(set) var isConnected: Bool = false
  public private(set) var connectionType: ConnectionType = .unknown

  // 연결타입
  enum ConnectionType {
    case wifi
    case cellular
    case ethernet
    case unknown
  }

  // monotior 초기화
  private init() {
    self.monitor = NWPathMonitor()
  }

  // Network Monitoring 시작
  public func startMonitoring() {
    self.monitor.start(queue: queue)
    self.monitor.pathUpdateHandler = { [weak self] path in

      self?.isConnected = path.status == .satisfied
      self?.getConnectionType(path)

      if self?.isConnected == true {
        print("연결됨!")
      } else {
        print("연결안됨!")
        // TODO: NetworkVC를 Root로 보여주기
      }
    }
  }

  // Network Monitoring 종료
  public func stopMonitoring() {
    self.monitor.cancel()
  }

  // Network 연결 타입
  private func getConnectionType(_ path: NWPath) {
    if path.usesInterfaceType(.wifi) {
      self.connectionType = .wifi
    } else if path.usesInterfaceType(.cellular) {
      self.connectionType = .cellular
    } else if path.usesInterfaceType(.wiredEthernet) {
      self.connectionType = .ethernet
    } else {
      self.connectionType = .unknown
    }
  }
}
