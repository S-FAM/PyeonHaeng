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
    case updateProduct(ProductModel)
    case back
    case bookmark(Bool)
    case share(UIImage)
  }

  enum Mutation {
    case updateProduct(ProductModel)
    case goToHomeVC
    case changeBookmarkState(Bool)
    case showShareWindow(Bool)
    case setItem(UIImage)
  }

  struct State {
    var model = ProductModel(imageLink: "", name: "", price: 0, store: .all, saleType: .all)
    var isPopProductVC: Bool = false
    var isBookmark: Bool = false
    var isShareButtonTapped: Bool = false
    var shareImage: UIImage?
  }

  var initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .updateProduct(let model):
      return .just(.updateProduct(model))
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
    case .goToHomeVC:
      newState.isPopProductVC = true
    case .changeBookmarkState(let isBookmark):
      newState.isBookmark = !isBookmark
    case let .showShareWindow(isShareButtonTapped):
      newState.isShareButtonTapped = isShareButtonTapped
    case let .setItem(newImage):
      newState.shareImage = newImage
    }

    return newState
  }
}
