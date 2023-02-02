//
//  ProductViewReactor.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2023/01/02.
//

import ReactorKit
import RxSwift
import RxCocoa

final class ProductViewReactor: Reactor {

  enum Action {
    case updateProduct(ProductModel)
    case back
  }

  enum Mutation {
    case updateProduct(ProductModel)
    case goToHomeVC
  }

  struct State {
    var model = ProductModel(imageLink: "", name: "", price: 0, store: .all, saleType: .all)
    var isPopProductVC: Bool = false
  }

  var initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .updateProduct(let model):
      return .just(.updateProduct(model))
    case .back:
      return .just(.goToHomeVC)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .updateProduct(let model):
      newState.model = model
    case .goToHomeVC:
      newState.isPopProductVC = true
    }

    return newState
  }
}
