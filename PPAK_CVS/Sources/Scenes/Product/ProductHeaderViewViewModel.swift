//
//  ProductHeaderViewViewModel.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/10/29.
//

import UIKit

import RxSwift

final class ProductHeaderViewViewModel: ViewModel {

  enum Action {
    case share(UIImage)
  }

  enum Mutation {
    case showShareWindow(Bool)
    case setItem(UIImage)
  }

  struct State {
    var isShareButtonTapped: Bool = false
    var shareImage: UIImage?
  }

  var initialState = State()
}

extension ProductHeaderViewViewModel {

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .share(image):
      // prevent from multiple requests
      guard self.currentState.isShareButtonTapped == false else { return .empty() }
      return .concat([
        .just(.showShareWindow(true)),
        .just(.setItem(image)),
        .just(.showShareWindow(false))
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var nextState = state

    switch mutation {
    case let .showShareWindow(isShareButtonTapped):
      nextState.isShareButtonTapped = isShareButtonTapped

    case let .setItem(newImage):
      nextState.shareImage = newImage
    }

    return nextState
  }
}
