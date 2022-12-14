//
//  TargetType.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/12/14.
//

import Foundation

import Alamofire

protocol TargetType: URLRequestConvertible {
  var baseURL: String { get }
  var method: HTTPMethod { get }
  var path: String { get }
  var parameters: Parameters { get }
}
