import RxSwift

final class BookmarkViewModel: ViewModel {

  enum Action {
    case didTapCVSButton
    case didTapSortButton
    case didTapBackButton
    case didChangeEvent(EventType)
    case didTapDropdownCVS(CVSDropdownCase)
    case didTapDropdownSort(SortType)
    case didChangeSearchBarText(String)
  }

  enum Mutation {
    case setCVSDropdown
    case setSortDropdown
    case setHomeVC(Bool)
    case hideDropdown
    case setCVS(CVSType)
    case setSort(SortType)
    case setEvent(EventType)
    case setTarget(String)
  }

  struct State {
    var isHiddenCVSDropdown: Bool = true
    var isHiddenSortDropdown: Bool = true
    var showsHomeVC: Bool = false
    var currentSort: SortType = .ascending
    var currentCVS: CVSType = .all
    var currentEvent: EventType = .all
    var currentTarget: String = ""
    var currentProducts: [ProductModel] = Storage.shared.products
  }

  var initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapCVSButton:
      return .just(.setCVSDropdown)

    case .didTapSortButton:
      return .just(.setSortDropdown)

    case .didTapBackButton:
      return .concat([
        .just(.setHomeVC(true)),
        .just(.setHomeVC(false))
      ])

    case .didChangeEvent(let event):
      return .concat([
        .just(.setEvent(event)),
        .just(.hideDropdown)
      ])

    case .didTapDropdownCVS(let cvsDropdownCase):
      switch cvsDropdownCase {
      case .cvs(let cvs):
        return .concat([
          .just(.setCVS(cvs)),
          .just(.hideDropdown)
        ])
        
      case .setting:
        return .empty()
      }

    case .didChangeSearchBarText(let target):
      return .just(.setTarget(target))

    case .didTapDropdownSort(let sort):
      return .concat([
        .just(.setSort(sort)),
        .just(.hideDropdown)
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var nextState = state

    switch mutation {
    case .setCVSDropdown:
      nextState.isHiddenCVSDropdown.toggle()
      nextState.isHiddenSortDropdown = true

    case .setSortDropdown:
      nextState.isHiddenSortDropdown.toggle()
      nextState.isHiddenCVSDropdown = true

    case .setHomeVC(let state):
      nextState.showsHomeVC = state

    case .hideDropdown:
      nextState.isHiddenSortDropdown = true
      nextState.isHiddenCVSDropdown = true

    case .setCVS(let cvsType):
      nextState.currentCVS = cvsType

    case .setSort(let filterDropdownCase):
      nextState.currentSort = filterDropdownCase

    case .setEvent(let event):
      nextState.currentEvent = event

    case .setTarget(let text):
      nextState.currentTarget = text
    }
    return nextState
  }
}
