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
    case didChangeSearchBar(String)
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
    case setTarget(String)
    case setOffset
    case setBlockRequest(Bool)
    case resetOffset
    case resetProducts
    case appendProductes([ProductModel])
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
    var isLoadingFromCell: Bool = false
    var isBlockedRequest: Bool = false
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
          offset: nextOffset,
          name: currentState.currentTarget
        )
        .delay(.seconds(1), scheduler: MainScheduler.instance)
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
        .just(.resetProducts),
        .just(.setBlockRequest(false)),
        .just(.resetOffset),
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
          .just(.setBlockRequest(false)),
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
        .just(.setBlockRequest(false)),
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
        .just(.setBlockRequest(false)),
        .just(.setTarget(target)),
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
      .just(.setBlockRequest(true)),
      PyeonHaengAPI.shared.product(request: RequestTypeModel(
        cvs: cvs,
        event: event,
        sort: sort,
        name: name,
        offset: offset
      ))
      .catch { _ in .empty() }
      .flatMap { response -> Observable<Mutation> in
        return .concat([
          .just(.appendProductes(response.products)),
          .just(.setBlockRequest(false))
        ])
      },
      .just(.setLoading(false)),
      .just(.setLoadingFromCell(false))
    ])
  }
}
