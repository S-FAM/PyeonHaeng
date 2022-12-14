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

extension TargetType {
  var baseURL: String {
    return PrivateKeys.url
  }

  func asURLRequest() throws -> URLRequest {
    let url = try baseURL.asURL()
    var request = try URLRequest(url: url.appendingPathComponent(path), method: method)

    // setting headers
    request.headers = .default

    // setting uri
    var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
    components?.queryItems = parameters.map { URLQueryItem(name: $0, value: "\($1)") }
    request.url = components?.url

    return request
  }
}
