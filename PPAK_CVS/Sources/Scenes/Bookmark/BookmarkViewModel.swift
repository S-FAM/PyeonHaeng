import RxSwift

final class BookmarkViewModel: ViewModel {

  enum Action {
    case didTapCVSButton
    case didTapSortButton
    case didTapBackButton
    case didChangeEvent(EventType)
    case didTapDropdownCVS(CVSDropdownCase)
    case didTapDropdownSort(SortType)
  }
  
  enum Mutation {
    case setCVSDropdown
    case setSortDropdown
    case setHomeVC
    case hideDropdown
    case setCVS(CVSType)
    case setSort(SortType)
    case setEvent(EventType)
  }
  
  struct State {
    var isHiddenCVSDropdown: Bool = true
    var isHiddenSortDropdown: Bool = true
    var showsHomeVC: Bool = false
    var currentSort: SortType = .ascending
    var currentCVS: CVSType? = .all
    var currentEvent: Int = 0
  }

  var initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapCVSButton:
      return Observable.just(.setCVSDropdown)

    case .didTapSortButton:
      return Observable.just(.setSortDropdown)
      
    case .didTapBackButton:
      return Observable.just(.setHomeVC)

    case .didChangeEvent(let index):
      return Observable.just(.onChnagedPageIndex(index))

    case .didTapDropdownCVS(let cvsDropdownCase):
      var newCvsType: CVSType?
      switch cvsDropdownCase {
      case .cvs(let cvsType):
        newCvsType = cvsType
      case .setting:
        break // 셋팅 페이지로 가야할 곳
      }
      return Observable.concat([
        Observable.just(.hideDropdown),
        Observable.just(.setCVS(newCvsType))
      ])

    case .didTapDropdownSort(let filterDropdownCase):
      return Observable.concat([
        Observable.just(.setSort(filterDropdownCase)),
        Observable.just(.hideDropdown)
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var nextState = state

    switch mutation {
    case .setCVSDropdown:
      nextState.isHiddenCVSDropdown.toggle()

    case .setSortDropdown:
      nextState.isHiddenSortDropdown.toggle()

    case .setHomeVC:
      nextState.showsHomeVC = true

    case .hideDropdown:
      nextState.isHiddenSortDropdown = false
      nextState.isHiddenCVSDropdown = false

    case .setCVS(let cvsType):
      nextState.currentCVS = cvsType

    case .setSort(let filterDropdownCase):
      nextState.currentSort = filterDropdownCase

    case .setEvent(let index):
      nextState.pageIndex = index
    }
    return nextState
  }
}
