//
//  ProductHeaderViewViewModel.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/10/29.
//

import Foundation

import RxSwift

final class ProductHeaderViewViewModel: ViewModel {

  enum Action {
    case share
  }

  enum Mutation {
    case showShareWindow(Bool)
  }

  struct State {
    var isShareButtonTapped: Bool = false
  }

  var initialState = State()
}

extension ProductHeaderViewViewModel {

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .share:
      // prevent from multiple requests
      guard self.currentState.isShareButtonTapped == false else { return .empty() }
      return .concat([
        .just(.showShareWindow(true)),
        .just(.showShareWindow(false))
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var nextState = state

    switch mutation {
    case let .showShareWindow(isShareButtonTapped):
      nextState.isShareButtonTapped = isShareButtonTapped
    }

    return nextState
  }
}
