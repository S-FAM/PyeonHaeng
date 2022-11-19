import RxSwift
import RxCocoa

final class HomeViewModel: ViewModel {
  
  enum Action {
    case requestProducts
    case currentCVSButtonDidTap
    case filterButtonDidTap
    case backgroundDidTap
    case bookmarkButtonDidTap
    case pageControlIndexDidChange(Int)
    case dropdownCVSButtonDidTap(CVSDropdownCase)
    case dropdownFilterButtonDidTap(FilterDropdownCase)
  }

  enum Mutation {
    case toggleCVSDropdown
    case toggleFilterDropdown
    case toggleShowBookmarkVC(Bool)
    case hideDropdown
    case updateCVSType(CVSType?)
    case updateFilter(FilterDropdownCase)
    case updatePageIndex(Int)
    case updateIndicatorState(Bool)
    case updateProducts([ProductModel])
  }

  struct State {
    var isVisibleCVSDropdown: Bool = false
    var isVisibleFilterDropdown: Bool = false
    var showBookmarkVC: Bool = false
    var currentFilter: FilterDropdownCase = .ascending
    var currentCVSType: CVSType? = .all
    var pageIndex: Int = 0
    var indicatorState: Bool = false
    var products: [ProductModel] = []
  }

  var initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .requestProducts:
      return Observable.concat([
        Observable.just(.updateIndicatorState(true)),
        CVSDatabase.shared.product(request: RequestTypeModel(
          cvs: .all,
          event: .all,
          sort: .none)
        )
        .flatMap { Observable.just(.updateProducts($0)) }
      ])

    case .currentCVSButtonDidTap:
      return Observable.just(.toggleCVSDropdown)

    case .filterButtonDidTap:
      return Observable.just(.toggleFilterDropdown)

    case .backgroundDidTap:
      return Observable.just(.hideDropdown)

    case .bookmarkButtonDidTap:
      guard currentState.showBookmarkVC == false else { return .empty() }
      return Observable.concat([
        Observable.just(.toggleShowBookmarkVC(true)),
        Observable.just(.toggleShowBookmarkVC(false))
      ])

    case .pageControlIndexDidChange(let index):
      return Observable.just(.updatePageIndex(index))

    case .dropdownCVSButtonDidTap(let cvsDropdownCase):
      var newCVSType: CVSType?
      switch cvsDropdownCase {
      case .cvs(let cvsType):
        newCVSType = cvsType
      case .setting:
        // TODO: Setting Page로 이동해야 합니다.
        break
      }
      return Observable.concat([
        Observable.just(.hideDropdown),
        Observable.just(.updateCVSType(newCVSType))
      ])

    case .dropdownFilterButtonDidTap(let filterDropdownCase):
      return Observable.concat([
        Observable.just(.updateFilter(filterDropdownCase)),
        Observable.just(.hideDropdown)
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var nextState = state

    switch mutation {
    case .updateProducts(let products):
      nextState.products = products
      nextState.indicatorState = false

    case .updateIndicatorState(let isAnimated):
      nextState.indicatorState = isAnimated

    case .toggleCVSDropdown:
      nextState.isVisibleCVSDropdown.toggle()

    case .toggleFilterDropdown:
      nextState.isVisibleFilterDropdown.toggle()

    case .hideDropdown:
      nextState.isVisibleFilterDropdown = false
      nextState.isVisibleCVSDropdown = false

    case let .toggleShowBookmarkVC(isShowBookmarkVC):
      nextState.showBookmarkVC = isShowBookmarkVC

    case .updateCVSType(let cvsType):
      nextState.currentCVSType = cvsType

    case .updateFilter(let filterDropdownCase):
      nextState.currentFilter = filterDropdownCase

    case .updatePageIndex(let index):
      nextState.pageIndex = index

    }
    return nextState
  }
}
