//
//  CVSDatabase.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/11/04.
//

import Foundation

import RxSwift
import RxCocoa
import FirebaseFirestore
import FirebaseFirestoreSwift

final class CVSDatabase {

  /// The shared singleton firebase object.
  static let shared: CVSDatabase = CVSDatabase()

  private lazy var database: CollectionReference = Firestore.firestore().collection("sale")

  var syncKey: Observable<String> {
    return self._syncKey().asObservable()
  }

  private func _syncKey() -> Single<String> {
    return Single.create { [weak self] observer in
      self?.database.document(Name.syncKey).getDocument(as: SyncKeyModel.self) { result in
        switch result {
        case let .success(keyModel):
          observer(.success(keyModel.month))
        case .failure:
          observer(.failure(Error.firebase))
        }
      }
      return Disposables.create()
    }
  }

  func informationTask(
    request: RequestTypeModel,
    offset: Int = 0,
    limit: Int = 10
  ) -> Observable<[ProductModel]> {
    return Single<[ProductModel]>.create { observer in
      let task = Task {
        do {
          let key = try await self._syncKey().value

          let dateFormatter = DateFormatter().then {
            $0.dateFormat = "yyyy:MM"
          }

          // 받아온 값으로 날짜변환이 되지 않는 경우
          guard let syncDate = dateFormatter.date(from: key) else {
            throw Error.decoding
          }

          // db에 저장되어있는 날짜(년/월)가 현재 날짜랑 맞지 않는 경우
          guard Date.now.year == syncDate.year && Date.now.month == syncDate.month else {
            throw Error.synchronized
          }

          observer(.success([]))
        } catch {
          observer(.failure(error))
        }
      }
      return Disposables.create {
        task.cancel()
      }
    }
    .asObservable()
  }
}

// MARK: - Models and Constants

extension CVSDatabase {

  enum Error: Swift.Error {

    /// Firebase를 읽어드리는 데 오류가 발생한 경우
    case firebase

    /// 데이터가 잘못 들어와 디코딩이 되지 않는 경우
    /// 이는 서버측의 데이터타입 문제이거나, 해당 클래스의 타입변경 미스일 때 발생합니다.
    case decoding

    /// 서버에 저장되어있는 데이터가 현재 날짜랑 맞지 않는 경우
    case synchronized
  }

  private enum Name {
    static let syncKey = "sync_key"
    static let price = "price"
    static let cvs = "store"
    static let item = "items"
    static let event = "tag"
  }

  private struct SyncKeyModel: Codable {
    let month: String
  }
}
