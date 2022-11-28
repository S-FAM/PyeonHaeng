import RxSwift

final class BookmarkViewModel: ViewModel {

  enum FilterDropdownCase {
    case ascending
    case descending
  }

  enum Action {
    case currentCVSButtonTapped
    case filterButtonTapped
    case backButtonTapped
    case backgroundTapped
    case pageControlIndexEvent(Int)
    case cvsButtonTappedInDropdown(CVSDropdownCase)
    case filterButtonTappedInDropdown(FilterDropdownCase)
  }

  enum Mutation {
    case toggleCVSDropdown
    case toggleFilterDropdown
    case toggleShowHomeVC
    case hideDropdown
    case onChangedCVSType(CVSType?)
    case onChangedFilter(FilterDropdownCase)
    case onChnagedPageIndex(Int)
  }

  struct State {
    var isVisibleCVSDropdown: Bool = false
    var isVisibleFilterDropdown: Bool = false
    var showHomeVC: Bool = false
    var currentFilter: FilterDropdownCase = .ascending
    var currentCVSType: CVSType? = .all
    var pageIndex: Int = 0
  }

  var initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .currentCVSButtonTapped:
      return Observable.just(.toggleCVSDropdown)

    case .filterButtonTapped:
      return Observable.just(.toggleFilterDropdown)

    case .backgroundTapped:
      return Observable.just(.hideDropdown)

    case .backButtonTapped:
      return Observable.just(.toggleShowHomeVC)

    case .pageControlIndexEvent(let index):
      return Observable.just(.onChnagedPageIndex(index))

    case .cvsButtonTappedInDropdown(let cvsDropdownCase):
      var newCvsType: CVSType?
      switch cvsDropdownCase {
      case .cvs(let cvsType):
        newCvsType = cvsType
      case .setting:
        break // 셋팅 페이지로 가야할 곳
      }
      return Observable.concat([
        Observable.just(.hideDropdown),
        Observable.just(.onChangedCVSType(newCvsType))
      ])

    case .filterButtonTappedInDropdown(let filterDropdownCase):
      return Observable.concat([
        Observable.just(.onChangedFilter(filterDropdownCase)),
        Observable.just(.hideDropdown)
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var nextState = state

    switch mutation {
    case .toggleCVSDropdown:
      nextState.isVisibleCVSDropdown.toggle()

    case .toggleFilterDropdown:
      nextState.isVisibleFilterDropdown.toggle()

    case .toggleShowHomeVC:
      nextState.showHomeVC = true

    case .hideDropdown:
      nextState.isVisibleFilterDropdown = false
      nextState.isVisibleCVSDropdown = false

    case .onChangedCVSType(let cvsType):
      nextState.currentCVSType = cvsType

    case .onChangedFilter(let filterDropdownCase):
      nextState.currentFilter = filterDropdownCase

    case .onChnagedPageIndex(let index):
      nextState.pageIndex = index
    }
    return nextState
  }
}
