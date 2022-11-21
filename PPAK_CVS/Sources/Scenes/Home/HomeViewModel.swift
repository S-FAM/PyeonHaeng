import RxSwift
import RxCocoa

final class HomeViewModel: ViewModel {

  enum Action {
    case currentCVSButtonTapped
    case filterButtonTapped
    case backgroundTapped
    case bookmarkButtonTapped
    case pageControlIndexEvent(Int)
    case cvsButtonTappedInDropdown(CVSDropdownCase)
    case filterButtonTappedInDropdown(FilterDropdownCase)
  }

  enum Mutation {
    case toggleCVSDropdown
    case toggleFilterDropdown
    case toggleShowBookmarkVC(Bool)
    case hideDropdown
    case onChangedCVSType(CVSType?)
    case onChangedFilter(FilterDropdownCase)
    case onChangedPageIndex(Int)
  }

  struct State {
    var isVisibleCVSDropdown: Bool = false
    var isVisibleFilterDropdown: Bool = false
    var showBookmarkVC: Bool = false
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

    case .bookmarkButtonTapped:
      guard currentState.showBookmarkVC == false else { return .empty() }
      return Observable.concat([
        Observable.just(.toggleShowBookmarkVC(true)),
        Observable.just(.toggleShowBookmarkVC(false))
      ])

    case .pageControlIndexEvent(let index):
      return Observable.just(.onChangedPageIndex(index))

    case .cvsButtonTappedInDropdown(let cvsDropdownCase):
      var newCVSType: CVSType?
      switch cvsDropdownCase {
      case .cvs(let cvsType):
        newCVSType = cvsType
      case .setting:
        break // 셋팅 페이지로 가야할 곳
      }
      return Observable.concat([
        Observable.just(.hideDropdown),
        Observable.just(.onChangedCVSType(newCVSType))
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

    case .hideDropdown:
      nextState.isVisibleFilterDropdown = false
      nextState.isVisibleCVSDropdown = false

    case let .toggleShowBookmarkVC(isShowBookmarkVC):
      nextState.showBookmarkVC = isShowBookmarkVC

    case .onChangedCVSType(let cvsType):
      nextState.currentCVSType = cvsType

    case .onChangedFilter(let filterDropdownCase):
      nextState.currentFilter = filterDropdownCase

    case .onChangedPageIndex(let index):
      nextState.pageIndex = index

    }
    return nextState
  }
}
