import ReactorKit
import Foundation
import RxSwift
import RxCocoa

final class SettingViewReactor: Reactor {

  enum Action {
    case defaultAction
    case didSelectRow(SettingCellType)
  }

  enum Mutation {
    case setPush
    case setSelectStore
    case setNotice
    case setReview
    case setSendMail
    case setSupportDeveloper
    case defaultMutation
  }

  struct State {
    var selectedCell: SettingCellType?
  }

  var initialState: State = State()

  // 연결과정을 결합하는 곳
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .defaultAction:
      return Observable.just(.defaultMutation)

    case .didSelectRow(let currentCellType):
      switch currentCellType {
      case .push:
        return Observable.just(.setPush)
      case .selectStore:
        return Observable.just(.setSelectStore)
      case .notice:
        return Observable.just(.setNotice)
      case .review:
        return Observable.just(.setReview)
      case .sendMail:
        return Observable.just(.setSendMail)
      case .supportDeveloper:
        return Observable.just(.setSupportDeveloper)
      default:
        return Observable.just(.defaultMutation)
      }
    }
  }

  // 변수로 들어오는 state에 따라 mutation을 처리된 state
  func reduce(state: State, mutation: Mutation) -> State {
    var nextState = state

    switch mutation {
    case .defaultMutation:
      print("default")

    case .setPush:
      nextState.selectedCell = .push
      print("isAlarmAction")

    case .setNotice:
      nextState.selectedCell = .notice
      print("moveToNoticeVC")

    case .setSelectStore:
      nextState.selectedCell = .selectStore
      print("setSelectStore")

    case .setReview:
      nextState.selectedCell = .review
      print("isReviewAction")

    case .setSendMail:
      nextState.selectedCell = .sendMail
      print("isSendMailAction")

    case .setSupportDeveloper:
      nextState.selectedCell = .supportDeveloper
      print("setSupportDeveloper")
    }
    return nextState
  }

}
