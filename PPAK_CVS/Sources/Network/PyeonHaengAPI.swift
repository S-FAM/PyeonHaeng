//
//  PyeonHaengAPI.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/12/14.
//

import Foundation

import Alamofire
import RxSwift

final class PyeonHaengAPI {

  static let shared = PyeonHaengAPI()

  func product(request: RequestTypeModel) -> Observable<ResponseModel> {
    return Single.create { observer in
      AF.request(ProductTarget.search(request))
        .responseDecodable(of: ResponseModel.self) { response in
          switch response.result {
          case .success(let model):
            observer(.success(model))
          case .failure(let error):
            observer(.failure(error))
          }
        }

      return Disposables.create()
    }
    .asObservable()
  }

  func history(request: RequestHistoryModel) -> Observable<ResponseModel> {
    return Single.create { observer in
      AF.request(ProductTarget.history(request))
        .responseDecodable(of: ResponseModel.self) { response in
          switch response.result {
          case .success(let model):
            observer(.success(model))
          case .failure(let error):
            observer(.failure(error))
          }
        }

      return Disposables.create()
    }
    .asObservable()
  }
}
