//
//  ProductViewModel.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2023/01/02.
//

import RxSwift
import RxCocoa

final class ProductViewModel: ViewModel {

  enum Action {
    case updateProduct(ProductModel)
  }

  enum Mutation {
    case updateProduct(ProductModel)
  }

  struct State {
    var model = ProductModel(imageLink: "", name: "", price: 0, store: .all, saleType: .all)
  }

  var initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .updateProduct(let model):
      return .just(.updateProduct(model))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .updateProduct(let model):
      newState.model = model
    }

    return newState
  }
}
