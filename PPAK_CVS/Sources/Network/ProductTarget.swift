//
//  ProductTarget.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/12/14.
//

import Foundation

import Alamofire

enum ProductTarget {
  case name(String)
  case filter(RequestTypeModel)
}
