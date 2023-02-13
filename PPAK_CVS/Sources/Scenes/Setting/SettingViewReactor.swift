import ReactorKit
import RxSwift
import RxCocoa

final class SettingViewReactor: Reactor {

  enum Action {
    case defaultAction
    case didTapNoticeButton
  }

  enum Mutation {
    case defaultMutation
    case setNoticeVC(Bool)
  }

  struct State {
    var value: Int = 0
    var showNoticeVC: Bool = false
  }

  var initialState: State = State()

  // 연결과정을 결합하는 곳
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapNoticeButton:
      return .concat([.just(.setNoticeVC(true)),
                      .just(.setNoticeVC(false))
      ])
    case .defaultAction:
      return Observable.just(.defaultMutation)
    }
  }

  // 변수로 들어오는 state에 따라 mutation을 처리된 state
  func reduce(state: State, mutation: Mutation) -> State {
    var nextState = state

    switch mutation {
    case .defaultMutation:
      break
    case .setNoticeVC(let state):
      nextState.showNoticeVC = state
      print("moveToNoticeVC")
    }
    return nextState
  }

}
