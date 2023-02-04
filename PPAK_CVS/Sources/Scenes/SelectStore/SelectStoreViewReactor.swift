//
//  SelectStoreViewReactor.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2023/02/05.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

final class SelectStoreViewReactor: Reactor {
  enum Action {
    case selectStore(CVSType)
    case skip
  }
  
  enum Mutation {
    case goToHomeVC
  }
  
  struct State {
    var isPushHomeVC: Bool = false
  }
  
  let initialState: State = State()
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .selectStore(let cvsType):
      CVSStorage.shared.saveToFavorite(cvsType)
      return .just(.goToHomeVC)
    case .skip:
      CVSStorage.shared.saveToFavorite(.all)
      return .just(.goToHomeVC)
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var nextState = state
    
    switch mutation {
    case .goToHomeVC:
      nextState.isPushHomeVC = true
    }
    
    return nextState
  }
}
