//
//  DeviceManager.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2023/02/24.
//

import UIKit

import DeviceKit

final class DeviceManager {

  static var isNotched: Bool {
    let targetDevices =
    Device.allDevicesWithSensorHousing + Device.allSimulatorDevicesWithSensorHousing
    return Device.current.isOneOf(targetDevices)
  }
}
