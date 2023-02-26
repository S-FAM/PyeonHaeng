//
//  ProductViewReactor.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2023/01/02.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

final class ProductViewReactor: Reactor {

  enum Action {
    case fetchProduct(ProductModel)
    case back
    case bookmark(Bool)
    case share(UIImage)
  }

  enum Mutation {
    case updateProduct(ProductModel)
    case updateHistoryProduct([ProductModel])
    case goToHomeVC
    case fetchBookmark(Bool)
    case changeBookmarkState(Bool)
    case showShareWindow(Bool)
    case setItem(UIImage)
  }

  struct State {
    var model = ProductModel(imageLink: "", name: "", dateString: "", price: 0, store: .all, saleType: .all)
    var historyModels: [ProductModel] = []
    var isPopProductVC: Bool = false
    var isBookmark: Bool = false
    var isShareButtonTapped: Bool = false
    var shareImage: UIImage?
  }

  var initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetchProduct(let model):
      return .concat([
        .just(.updateProduct(model)),
        .just(.changeBookmarkState(ProductStorage.shared.contains(model))),
        // API 요청 후 Mutation으로 매핑
        PyeonHaengAPI.shared.history(request: RequestHistoryModel(cvs: model.store, name: model.name))
          .flatMap { Observable<Mutation>.just(.updateHistoryProduct($0.products.reversed())) }
      ])

    case .back:
      return .just(.goToHomeVC)

    case .bookmark(let isBookmark):
      return .just(.changeBookmarkState(isBookmark))

    case let .share(image):
      // prevent from multiple requests
      if self.currentState.isShareButtonTapped {
        return .empty()
      }
      return .concat([
        .just(.showShareWindow(true)),
        .just(.setItem(image)),
        .just(.showShareWindow(false))
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .updateProduct(let model):
      newState.model = model

    case .updateHistoryProduct(let models):
      newState.historyModels = models

    case .goToHomeVC:
      newState.isPopProductVC = true

    case .fetchBookmark(let isBookmark):
      newState.isBookmark = isBookmark

    case .changeBookmarkState(let isBookmark):
      self.updateBookmarkState(isBookmark: isBookmark)
      newState.isBookmark = isBookmark

    case let .showShareWindow(isShareButtonTapped):
      newState.isShareButtonTapped = isShareButtonTapped

    case let .setItem(newImage):
      newState.shareImage = newImage
    }

    return newState
  }

  /// 북마크 상태를 UserDefaults에 적용하는 메서드입니다.
  private func updateBookmarkState(isBookmark: Bool) {
    // guard isBookmark else { return } // 또는
    if !isBookmark { return }

    let storage = ProductStorage.shared

    if storage.contains(currentState.model) {
      storage.remove(currentState.model)
    } else {
      storage.add(currentState.model)
    }
  }
}
