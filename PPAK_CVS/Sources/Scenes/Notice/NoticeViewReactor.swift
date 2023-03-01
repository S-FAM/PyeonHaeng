//
//  NoticeViewReactor.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2023/02/18.
//

import Foundation

import ReactorKit
import RxSwift
import RxCocoa

final class NoticeViewReactor: Reactor {

  enum Action {
    case back
  }

  enum Mutation {
    case goToSettingVC
  }

  struct State {
    var isPopNoticetVC: Bool = false
  }

  var initialState: State = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .back:
      return .just(.goToSettingVC)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var nextState = state

    switch mutation {
    case .goToSettingVC:
      nextState.isPopNoticetVC = true
    }

    return nextState
  }
}
