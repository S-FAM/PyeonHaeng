//
//  OnboardingViewReactor.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/10/05.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

final class OnboardingViewReactor: Reactor {
  enum Action {
    case skip
    case next
    case leftSwipe
    case rightSwipe
  }

  enum Mutation {
    case goToNextPage
    case goToPreviousPage
    case goToSelectStoreVC
  }

  struct State {
    var currentPage: Int = 0
    var isPushSelectStoreVC: Bool = false
  }

  let initialState: State = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .skip:
      return Observable.just(Mutation.goToSelectStoreVC)
    case .next, .leftSwipe:
      return Observable.just(Mutation.goToNextPage)
    case .rightSwipe:
      return Observable.just(Mutation.goToPreviousPage)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var nextState = state

    switch mutation {
    case .goToSelectStoreVC:
      nextState.isPushSelectStoreVC = true
    case .goToNextPage:
      if nextState.currentPage < 2 {
        nextState.currentPage += 1
      } else {
        nextState.isPushSelectStoreVC = true
      }
    case .goToPreviousPage:
      if nextState.currentPage > 0 {
        nextState.currentPage -= 1
      }
    }
    return nextState
  }
}
