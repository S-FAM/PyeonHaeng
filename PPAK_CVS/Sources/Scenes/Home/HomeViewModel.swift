import RxSwift
import RxCocoa

final class HomeViewModel: ViewModel {

  enum Action {
    case viewDidLoad
    case currentCVSButtonDidTap
    case filterButtonDidTap
    case backgroundDidTap
    case bookmarkButtonDidTap
    case pageControlIndexDidChange(EventType)
    case dropdownCVSButtonDidTap(CVSDropdownCase)
    case dropdownFilterButtonDidTap(SortType)
  }

  enum Mutation {
    case toggleCVSDropdown
    case toggleFilterDropdown
    case toggleShowBookmarkVC(Bool)
    case hideDropdown
    case updateCVSType(CVSType)
    case updateSortType(SortType)
    case updateEventType(EventType)
    case updateIndicatorState(Bool)
    case updateProducts([ProductModel])
  }

  struct State {
    var isVisibleCVSDropdown: Bool = false
    var isVisibleFilterDropdown: Bool = false
    var showBookmarkVC: Bool = false
    var currentSortType: SortType = .none
    var currentEventType: EventType = .all
    var currentCVSType: CVSType = .all
    var indicatorState: Bool = false
    var products: [ProductModel] = []
  }

  var initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return requestProducts()

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

    case .pageControlIndexDidChange(let event):
      return Observable.concat([
        Observable.just(.updateIndicatorState(true)),
        Observable.just(.updateEventType(event)),
        requestProducts(cvs: currentState.currentCVSType, event: event, sort: currentState.currentSortType)
      ])

    case .dropdownCVSButtonDidTap(let cvsDropdownCase):
      switch cvsDropdownCase {
      case .cvs(let cvsType):
        return Observable.concat([
          Observable.just(.hideDropdown),
          Observable.just(.updateCVSType(cvsType)),
          requestProducts(cvs: cvsType, event: currentState.currentEventType, sort: currentState.currentSortType)
        ])
      case .setting:
        // TODO: Setting Page로 이동해야 합니다.
        return Observable.just(.hideDropdown)
      }

    case .dropdownFilterButtonDidTap(let sortType):
      return Observable.concat([
        Observable.just(.updateSortType(sortType)),
        Observable.just(.hideDropdown)
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var nextState = state

    switch mutation {
    case .updateProducts(let products):
      print(products)
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

    case .updateEventType(let eventType):
      nextState.currentEventType = eventType

    case .updateCVSType(let cvsType):
      nextState.currentCVSType = cvsType

    case .updateSortType(let sortType):
      nextState.currentSortType = sortType

    }
    return nextState
  }
}

extension HomeViewModel {
  func requestProducts(cvs: CVSType = .all, event: EventType = .all, sort: SortType = .none) -> Observable<Mutation> {
    return Observable.concat([
      Observable.just(.updateIndicatorState(true)),
      CVSDatabase.shared.product(request: RequestTypeModel(
        cvs: cvs,
        event: event,
        sort: sort)
      )
      .flatMap { Observable.just(.updateProducts($0)) }
    ])
  }
}
