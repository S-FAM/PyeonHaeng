import RxSwift
import RxCocoa

final class HomeViewModel: ViewModel {

  enum Action {
    case currentCvsButtonTapped
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
    case onChangedCvsImage(CVSDropdownCase)
    case onChangedFilter(FilterDropdownCase)
    case onChnagedPageIndex(Int)
  }

  struct State {
    var isVisibleCvsDropdown: Bool = false
    var isVisibleFilterDropdown: Bool = false
    var currentCvsImage: CVSDropdownCase = .all
    var currentFilter: FilterDropdownCase = .ascending
    var pageIndex: Int = 0
  }

  var initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .currentCvsButtonTapped:
      return Observable.just(.toggleCvsDropdown)
    case .filterButtonTapped:
      return Observable.just(.toggleFilterDropdown)
    case .backgroundTapped:
      return Observable.just(.hideDropdown)
    case .pageControlIndexEvent(let index):
      return Observable.just(.onChnagedPageIndex(index))
    case .cvsButtonTappedInDropdown(let cvsDropdownCase):
      return Observable.just(.onChangedCvsImage(cvsDropdownCase))
    case .filterButtonTappedInDropdown(let filterDropdownCase):
      return Observable.just(.onChangedFilter(filterDropdownCase))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var nextState = state

    switch mutation {
    case .toggleCvsDropdown:
      nextState.isVisibleCvsDropdown.toggle()
    case .toggleFilterDropdown:
      nextState.isVisibleFilterDropdown.toggle()
    case .hideDropdown:
      nextState.isVisibleFilterDropdown = false
      nextState.isVisibleCvsDropdown = false
    case .onChangedCvsImage(let cvsDropdownCase):
      nextState.currentCvsImage = cvsDropdownCase
    case .onChangedFilter(let filterDropdownCase):
      nextState.currentFilter = filterDropdownCase
    case .onChnagedPageIndex(let index):
      nextState.pageIndex = index
    }
    return nextState
  }
}
