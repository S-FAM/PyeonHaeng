import RxSwift
import RxCocoa

final class HomeViewModel: ViewModel {

  enum Action {
    case viewDidLoad
    case currentCVSButtonDidTap
    case filterButtonDidTap
    case bookmarkButtonDidTap
    case pageControlIndexDidChange(EventType)
    case dropdownCVSButtonDidTap(CVSDropdownCase)
    case dropdownFilterButtonDidTap(SortType)
    case didChangeSearchBar(String)
    case fetchMoreData
  }

  enum Mutation {
    case setCVSDropdown(Bool)
    case setFilterDropdown(Bool)
    case toggleShowBookmarkVC(Bool)
    case hideDropdown
    case setCVS(CVSType)
    case setSort(SortType)
    case setEvent(EventType)
    case setLoading(Bool)
    case setTarget(String)
    case setOffset
    case setBlockRequest(Bool)
    case resetOffset
    case resetProducts
    case appendProductes([ProductModel])
    case setPagination(Bool)
  }

  struct State {
    var isVisibleCVSDropdown: Bool = false
    var isVisibleFilterDropdown: Bool = false
    var showBookmarkVC: Bool = false
    var currentSortType: SortType = .none
    var currentEventType: EventType = .all
    var currentCVSType: CVSType = .all
    var currentTarget: String = ""
    var isLoading: Bool = false
    var isBlockedRequest: Bool = false
    var isPagination: Bool = false
    var products: [ProductModel] = []
    var currentOffset: Int = 0
  }

  var initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return requestProducts(cvs: .all, event: .all, sort: .none)

    case .fetchMoreData:
      let nextOffset = currentState.currentOffset + 20
      return .concat([
        .just(.setPagination(true)),
        .just(.setOffset),
        requestProducts(
          cvs: currentState.currentCVSType,
          event: currentState.currentEventType,
          sort: currentState.currentSortType,
          offset: nextOffset,
          name: currentState.currentTarget
        )
        .delay(.seconds(1), scheduler: MainScheduler.instance)
      ])

    case .currentCVSButtonDidTap:
      let isVisible = currentState.isVisibleCVSDropdown
      return .concat([
        .just(.setCVSDropdown(!isVisible)),
        .just(.setFilterDropdown(false))
      ])

    case .filterButtonDidTap:
      let isVisible = currentState.isVisibleFilterDropdown
      return .concat([
        .just(.setFilterDropdown(!isVisible)),
        .just(.setCVSDropdown(false))
      ])

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
        .just(.resetProducts),
        .just(.resetOffset),
        .just(.hideDropdown),
        requestProducts(
          cvs: currentState.currentCVSType,
          event: event,
          sort: .none,
          name: currentState.currentTarget
        )
      ])

    case .dropdownCVSButtonDidTap(let cvsDropdownCase):
      switch cvsDropdownCase {
      case .cvs(let cvsType):
        return .concat([
          .just(.setLoading(true)),
          .just(.hideDropdown),
          .just(.setCVS(cvsType)),
          .just(.setTarget("")),
          .just(.resetProducts),
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
        .just(.hideDropdown),
        .just(.setSort(sortType)),
        .just(.resetProducts),
        .just(.resetOffset),
        requestProducts(
          cvs: currentState.currentCVSType,
          event: currentState.currentEventType,
          sort: sortType,
          name: currentState.currentTarget
        )
      ])

    case .didChangeSearchBar(let target):
      return .concat([
        .just(.setLoading(true)),
        .just(.resetProducts),
        .just(.resetOffset),
        .just(.setTarget(target)),
        .just(.hideDropdown),
        requestProducts(
          cvs: currentState.currentCVSType,
          event: currentState.currentEventType,
          sort: currentState.currentSortType,
          name: target
        )
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var nextState = state

    switch mutation {
    case .resetProducts:
      nextState.products = []

    case .appendProductes(let products):
      nextState.products += products

    case .setLoading(let isLoading):
      nextState.isLoading = isLoading

    case .setCVSDropdown(let isVisible):
      nextState.isVisibleCVSDropdown = isVisible

    case .setFilterDropdown(let isVisible):
      nextState.isVisibleFilterDropdown = isVisible

    case .hideDropdown:
      nextState.isVisibleFilterDropdown = false
      nextState.isVisibleCVSDropdown = false

    case let .toggleShowBookmarkVC(isShowBookmarkVC):
      nextState.showBookmarkVC = isShowBookmarkVC

    case .setOffset:
      nextState.currentOffset += 20

    case .setEvent(let eventType):
      nextState.currentEventType = eventType

    case .setCVS(let cvsType):
      nextState.currentCVSType = cvsType

    case .setSort(let sortType):
      nextState.currentSortType = sortType

    case .resetOffset:
      nextState.currentOffset = 0

    case .setTarget(let target):
      nextState.currentTarget = target

    case .setBlockRequest(let isBlocked):
      nextState.isBlockedRequest = isBlocked

    case .setPagination(let isPagination):
      nextState.isPagination = isPagination
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
    return .concat([
      PyeonHaengAPI.shared.product(request: RequestTypeModel(
        cvs: cvs,
        event: event,
        sort: sort,
        name: name,
        offset: offset
      ))
      .catch { _ in .empty() }
      .flatMap { response -> Observable<Mutation> in
        if response.count < 20 {
          return .concat([
            .just(.setBlockRequest(true)),
            .just(.appendProductes(response.products))
          ])
        } else {
          return .concat([
            .just(.setBlockRequest(false)),
            .just(.appendProductes(response.products))
          ])
        }
      },
      .just(.setLoading(false)),
      .just(.setPagination(false))
    ])
  }
}
