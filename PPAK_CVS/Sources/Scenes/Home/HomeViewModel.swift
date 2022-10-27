import RxSwift
import RxCocoa

final class HomeViewModel: ViewModel {

  enum Action {
    case currentCVSButtonTapped
    case filterButtonTapped
    case backgroundTapped
    case pageControlIndexEvent(Int)
    case cvsButtonTappedInDropdown(CVSDropdownCase)
    case filterButtonTappedInDropdown(FilterDropdownCase)
  }

  enum Mutation {
    case toggleCvsDropdown
    case toggleFilterDropdown
    case hideDropdown
    case onChangedCVSImage(CVSDropdownCase)
    case onChangedFilter(FilterDropdownCase)
    case onChnagedPageIndex(Int)
  }

  struct State {
    var isVisibleCVSDropdown: Bool = false
    var isVisibleFilterDropdown: Bool = false
    var currentCVSImage: CVSDropdownCase = .all
    var currentFilter: FilterDropdownCase = .ascending
    var pageIndex: Int = 0
  }

  var initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .currentCVSButtonTapped:
      return Observable.just(.toggleCvsDropdown)
    case .filterButtonTapped:
      return Observable.just(.toggleFilterDropdown)
    case .backgroundTapped:
      return Observable.just(.hideDropdown)
    case .pageControlIndexEvent(let index):
      return Observable.just(.onChnagedPageIndex(index))
    case .cvsButtonTappedInDropdown(let cvsDropdownCase):
      return Observable.just(.onChangedCVSImage(cvsDropdownCase))
    case .filterButtonTappedInDropdown(let filterDropdownCase):
      return Observable.just(.onChangedFilter(filterDropdownCase))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var nextState = state

    switch mutation {
    case .toggleCvsDropdown:
      nextState.isVisibleCVSDropdown.toggle()
    case .toggleFilterDropdown:
      nextState.isVisibleFilterDropdown.toggle()
    case .hideDropdown:
      nextState.isVisibleFilterDropdown = false
      nextState.isVisibleCVSDropdown = false
    case .onChangedCVSImage(let cvsDropdownCase):
      nextState.currentCVSImage = cvsDropdownCase
    case .onChangedFilter(let filterDropdownCase):
      nextState.currentFilter = filterDropdownCase
    case .onChnagedPageIndex(let index):
      nextState.pageIndex = index
    }
    return nextState
  }
}
