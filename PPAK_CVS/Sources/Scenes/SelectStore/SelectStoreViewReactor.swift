//
//  SelectStoreViewReactor.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2023/02/05.
//

import AVFoundation
import UIKit

import ReactorKit
import RxSwift
import RxCocoa

final class SelectStoreViewReactor: Reactor {
  enum Action {
    case selectStore(CVSType, Bool, Bool)
    case skip
    case save
  }
  
  enum Mutation {
    case goToHomeVC
    case popSelectStoreVC
    case updateSelectButton
  }
  
  struct State {
    var isPushHomeVC: Bool = false
    var isPopSelectStoreVC: Bool = false
    var updateSelectButton: Bool = false
  }
  
  let initialState: State = State()
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .selectStore(let cvsType, let isSelected, let fromSettings):
      AudioServicesPlaySystemSound(1520)
      if isSelected {
        CVSStorage.shared.saveToFavorite(.all)
      } else {
        CVSStorage.shared.saveToFavorite(cvsType)
      }
      return fromSettings ? .just(.updateSelectButton) : .just(.goToHomeVC)
    case .skip:
      CVSStorage.shared.saveToFavorite(.all)
      return .just(.goToHomeVC)
    case .save:
      return .just(.popSelectStoreVC)
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var nextState = state
    
    switch mutation {
    case .goToHomeVC:
      nextState.isPushHomeVC = true
    case .popSelectStoreVC:
      nextState.isPopSelectStoreVC = true
    case .updateSelectButton:
      nextState.updateSelectButton = true
    }
    
    return nextState
  }
}
