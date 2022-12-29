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
    case loadingCellWillDisplay
  }

  enum Mutation {
    case toggleCVSDropdown
    case toggleFilterDropdown
    case toggleShowBookmarkVC(Bool)
    case hideDropdown
    case setCVS(CVSType)
    case setSort(SortType)
    case setEvent(EventType)
    case setLoading(Bool)
    case setLoadingFromCell(Bool)
    case setOffset
    case setProducts([ProductModel])
  }

  struct State {
    var isVisibleCVSDropdown: Bool = false
    var isVisibleFilterDropdown: Bool = false
    var showBookmarkVC: Bool = false
    var currentSortType: SortType = .none
    var currentEventType: EventType = .all
    var currentCVSType: CVSType = .all
    var isLoading: Bool = false
    var isLoadingFromCell: Bool = false
    var products: [ProductModel] = []
    var currentOffset: Int = 0
  }

  var initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return requestProducts(cvs: .all, event: .all, sort: .none)

    case .loadingCellWillDisplay:
      let nextOffset = currentState.currentOffset + 20
      return .concat([
        .just(.setLoadingFromCell(true)),
        .just(.setOffset),
        requestProducts(
          cvs: currentState.currentCVSType,
          event: currentState.currentEventType,
          sort: currentState.currentSortType,
          offset: nextOffset)
      ])

    case .currentCVSButtonDidTap:
      return .just(.toggleCVSDropdown)

    case .filterButtonDidTap:
      return .just(.toggleFilterDropdown)

    case .backgroundDidTap:
      return .just(.hideDropdown)

    case .bookmarkButtonDidTap:
      guard currentState.showBookmarkVC == false else { return .empty() }
      return .concat([
        .just(.toggleShowBookmarkVC(true)),
        .just(.toggleShowBookmarkVC(false))
      ])

    case .pageControlIndexDidChange(let event):
      return .concat([
        .just(.setLoading(true)),
        .just(.setEvent(event)),
        .just(.setProducts([])),
        requestProducts(
          cvs: currentState.currentCVSType,
          event: event,
          sort: .none
        )
      ])

    case .dropdownCVSButtonDidTap(let cvsDropdownCase):
      switch cvsDropdownCase {
      case .cvs(let cvsType):
        return .concat([
          .just(.setLoading(true)),
          .just(.hideDropdown),
          .just(.setCVS(cvsType)),
          .just(.setProducts([])),
          requestProducts(
            cvs: cvsType,
            event: currentState.currentEventType,
            sort: .none
          )
        ])

      case .setting:
        // TODO: Setting Page로 이동해야 합니다.
        return .just(.hideDropdown)
      }

    case .dropdownFilterButtonDidTap(let sortType):
      return .concat([
        .just(.setLoading(true)),
        .just(.setSort(sortType)),
        .just(.hideDropdown),
        .just(.setProducts([])),
        requestProducts(cvs: currentState.currentCVSType, event: currentState.currentEventType, sort: sortType)
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var nextState = state

    switch mutation {
    case .setProducts(let products):
      if products.isEmpty {
        nextState.products = []
      } else {
        nextState.products += products
      }

    case .setLoading(let isLoading):
      nextState.isLoading = isLoading

    case .toggleCVSDropdown:
      nextState.isVisibleCVSDropdown.toggle()

    case .toggleFilterDropdown:
      nextState.isVisibleFilterDropdown.toggle()

    case .hideDropdown:
      nextState.isVisibleFilterDropdown = false
      nextState.isVisibleCVSDropdown = false

    case let .toggleShowBookmarkVC(isShowBookmarkVC):
      nextState.showBookmarkVC = isShowBookmarkVC

    case .setLoadingFromCell(let isLoading):
      nextState.isLoadingFromCell = isLoading

    case .setOffset:
      nextState.currentOffset += 20

    case .setEvent(let eventType):
      nextState.currentEventType = eventType
      nextState.currentOffset = 0

    case .setCVS(let cvsType):
      nextState.currentCVSType = cvsType
      nextState.currentOffset = 0

    case .setSort(let sortType):
      nextState.currentSortType = sortType
      nextState.currentOffset = 0

    }
    return nextState
  }
}

extension HomeViewModel {
  func requestProducts(
    cvs: CVSType,
    event: EventType,
    sort: SortType,
    offset: Int = 0,
    name: String = ""
  ) -> Observable<Mutation> {
    return Observable.concat([
      PyeonHaengAPI.shared.product(request: RequestTypeModel(
        cvs: cvs,
        event: event,
        sort: sort,
        name: name,
        offset: offset
      ))
      .flatMap { Observable.just(.setProducts($0.products)) },
      .just(.setLoading(false)),
      .just(.setLoadingFromCell(false))
    ])
  }
}
