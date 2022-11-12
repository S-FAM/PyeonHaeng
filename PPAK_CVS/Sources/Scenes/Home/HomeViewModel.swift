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
    case onChangedCVSImage(CVSDropdownCase)
    case onChangedFilter(FilterDropdownCase)
    case onChangedPageIndex(Int)
  }

  struct State {
    var isVisibleCVSDropdown: Bool = false
    var isVisibleFilterDropdown: Bool = false
    var showBookmarkVC: Bool = false
    var currentCVSImage: CVSDropdownCase = .all
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
      var cvsType: CVSType?
      switch cvsDropdownCase {
      case .all:
        cvsType = .all
      case .cu:
        cvsType = .cu
      case .emart:
        cvsType = .eMart
      case .gs:
        cvsType = .gs
      case .ministop:
        cvsType = .miniStop
      case .sevenEleven:
        cvsType = .sevenEleven
      case .setting:
        break
      }
      return Observable.concat([
        Observable.just(.onChangedCVSImage(cvsDropdownCase)),
        Observable.just(.hideDropdown),
        Observable.just(.onChangedCVSType(cvsType))
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

    case .onChangedCVSImage(let cvsDropdownCase):
      nextState.currentCVSImage = cvsDropdownCase

    case .onChangedFilter(let filterDropdownCase):
      nextState.currentFilter = filterDropdownCase

    case .onChangedPageIndex(let index):
      nextState.pageIndex = index

    }
    return nextState
  }
}
