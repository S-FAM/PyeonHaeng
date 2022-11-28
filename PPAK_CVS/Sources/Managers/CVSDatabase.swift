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

  /// 데이터베이스에 저장되어있는 편의점 할인날짜
  var syncKey: Observable<String> {
    return self._syncKey().asObservable()
  }

  /// 특정 조건에 맞는 제품을 가져옵니다.
  /// - Parameters:
  ///   - request: 요청할 제품의 조건식을 갖는 모델
  ///   - offset: 보여줄 인덱스, 또는 위치
  ///   - limit: 보여줄 제품의 수
  /// - Returns: [ProductModel] 타입의 Observable을 리턴합니다.
  ///
  /// request model을 가지고 제품을 요청하되, Pagination을 위해서 offset과 limit 파라미터 값을 적절히 수정할 필요가 있습니다.
  /// 다음은 cu 편의점에 대해 2+1인 제품을 정렬하지 않고 가져오며, 해당 조건에 대해 10번째 제품부터 20개까지 요청하는 코드입니다.
  /// ```
  /// let model: RequestTypeModel = RequestTypeModel(
  ///   cvs: .cu,               // cu 편의점인데
  ///   event: .twoPlusOne,     // 2+1인 제품
  ///   sort: .none             // 정렬 상관없이
  /// )
  /// product(request: model, offset: 10, limit: 20)
  ///   .asDriver(onErrorJustReturn: [])
  ///   .drive { product in
  ///     // UI Codes...
  ///   }
  ///   .disposed(by: disposeBag)
  /// ```
  /// 만약 모든 편의점에 대해 모든 할인행사를 갖고오고 싶고, 가격 오름차순 정렬을 통해 처음부터 100개의 제품을 가져와 보여주고 싶다면 다음과 같은 코드를 작성하면 됩니다.
  /// 참고로 처음부터 가지고오는 경우 offset의 기본값은 0이므로 생략가능합니다.
  /// ```
  /// let model: RequestTypeModel = RequestTypeModel(
  ///   cvs: .all,          // 모든 편의점에 대해
  ///   event: .all,        // 모든 할인행사를 가지고
  ///   sort: .ascending    // 오름차순으로
  /// )
  /// product(request: model, limit: 100)
  ///   .asDriver(onErrorJustReturn: [])
  ///   .drive { product in
  ///     // UI Codes...
  ///   }
  ///   .disposed(by: disposeBag)
  /// ```
  ///
  /// 만약 syncKey값으로 firebase에 접근하여 가져오고 싶다면 syncKey 프로퍼티를 이용하여 가져올 수 있습니다.
  /// ```
  /// CVSDatabase.shared.syncKey
  ///   .flatMap { key in
  ///     CVSDatabase.shared.product(
  ///       request: RequestTypeModel(cvs: .eMart, event: .twoPlusOne, sort: .ascending),
  ///       key: key
  ///     )
  ///   }
  ///   .subscribe { products in
  ///     // codes...
  ///   }
  ///   .disposed(by: disposeBag)
  /// ```
  func product(
    request: RequestTypeModel,
    key: String? = nil,
    offset: Int = 0,
    limit: Int = 10
  ) -> Observable<[ProductModel]> {
    return Single<[ProductModel]>.create { observer in
      let task = Task {
        do {
          let unwrappedKey: String

          if let key = key {
            unwrappedKey = key
          } else {
            unwrappedKey = try await self._syncKey().value

            let dateFormatter = DateFormatter().then {
              $0.dateFormat = "yyyy:MM"
            }

            // 받아온 값으로 날짜변환이 되지 않는 경우
            guard let syncDate = dateFormatter.date(from: unwrappedKey) else {
              throw Error.decoding
            }

            // db에 저장되어있는 날짜(년/월)가 현재 날짜랑 맞지 않는 경우
            guard Date.now.year == syncDate.year && Date.now.month == syncDate.month else {
              throw Error.synchronized
            }
          }
          // == ok. access to firebase ==
          let query = self._query(model: request, key: unwrappedKey)

          var snapshot: QuerySnapshot

          if offset == 0 {
            snapshot = try await query
              .limit(to: limit)
              .getDocuments()
          } else {

            // offset부터 시작하는 문서를 가져오기 위함
            let offsetDocument = try await self._snapshot(query: query.limit(to: offset), offset: offset).value

            snapshot = try await query
              .limit(to: limit)
              .start(afterDocument: offsetDocument)
              .getDocuments()
          }

          let result = snapshot.documents.compactMap { document in
            return try? document.data(as: ProductModel.self)
          }

          observer(.success(result))
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

    /// 문서를 찾지 못한 경우
    case retrieving
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

// MARK: - Private Methods

extension CVSDatabase {

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

  private func _query(model: RequestTypeModel, key: String) -> Query {

    let ref = self.database.document(key).collection(Name.item)
    var query: Query = ref

    // 전부를 가져오는 것이 아닌 경우
    if model.cvs != .all && model.event != .all {
      query = query
        .whereField(Name.cvs, isEqualTo: model.cvs.rawValue)
        .whereField(Name.event, isEqualTo: model.event.rawValue)
    }
    // 이벤트 유형 전부를 가져오는 경우
    else if model.cvs != .all {
      query = query
        .whereField(Name.cvs, isEqualTo: model.cvs.rawValue)
    }
    // 편의점 유형 전부를 가져오는 경우
    else if model.event != .all {
      query = query
        .whereField(Name.event, isEqualTo: model.event.rawValue)
    }

    if model.sort == .none {
      return query
    }

    return query
      .order(by: Name.price, descending: model.sort == .descending ? true : false)
  }

  private func _snapshot(query: Query, offset: Int) -> Single<QueryDocumentSnapshot> {
    return Single.create { observer in

      let listener = query.addSnapshotListener { snapshot, _ in
        guard let snapshot = snapshot else {
          observer(.failure(Error.retrieving))
          return
        }

        guard let lastSnapshot = snapshot.documents.last else {
          observer(.failure(Error.retrieving)) // collection is empty if first access
          return
        }

        observer(.success(lastSnapshot))
      }

      return Disposables.create {
        listener.remove()
      }
    }
  }
}
