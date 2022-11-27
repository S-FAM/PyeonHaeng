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
    case updateCVSType(CVSType)
    case updateSortType(SortType)
    case updateEventType(EventType)
    case updateIsLoading(Bool)
    case updateIsLoadingFromCell(Bool)
    case updateOffset
    case updateProducts([ProductModel])
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
      let nextOffset = currentState.currentOffset + 10
      return Observable.concat([
        Observable.just(.updateIsLoadingFromCell(true)),
        Observable.just(.updateOffset),
        requestProducts(
          cvs: currentState.currentCVSType,
          event: currentState.currentEventType,
          sort: currentState.currentSortType,
          offset: nextOffset)
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

    case .pageControlIndexDidChange(let event):
      return Observable.concat([
        Observable.just(.updateIsLoading(true)),
        Observable.just(.updateEventType(event)),
        Observable.just(.updateProducts([])),
        requestProducts(
          cvs: currentState.currentCVSType,
          event: event,
          sort: currentState.currentSortType
        )
      ])

    case .dropdownCVSButtonDidTap(let cvsDropdownCase):
      switch cvsDropdownCase {
      case .cvs(let cvsType):
        return Observable.concat([
          Observable.just(.hideDropdown),
          Observable.just(.updateCVSType(cvsType)),
          Observable.just(.updateProducts([])),
          requestProducts(
            cvs: cvsType,
            event: currentState.currentEventType,
            sort: currentState.currentSortType
          )
        ])

      case .setting:
        // TODO: Setting Page로 이동해야 합니다.
        return Observable.just(.hideDropdown)
      }

    case .dropdownFilterButtonDidTap(let sortType):
      return Observable.concat([
        Observable.just(.updateSortType(sortType)),
        Observable.just(.hideDropdown),
        Observable.just(.updateProducts([])),
        requestProducts(cvs: currentState.currentCVSType, event: currentState.currentEventType, sort: sortType)
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var nextState = state

    switch mutation {
    case .updateProducts(let products):
      if products.isEmpty {
        nextState.products = []
      } else {
        nextState.products += products
      }

    case .updateIsLoading(let isLoading):
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

    case .updateIsLoadingFromCell(let isLoading):
      nextState.isLoadingFromCell = isLoading

    case .updateOffset:
      nextState.currentOffset += 10

    case .updateEventType(let eventType):
      nextState.currentEventType = eventType
      nextState.currentOffset = 0

    case .updateCVSType(let cvsType):
      nextState.currentCVSType = cvsType
      nextState.currentOffset = 0

    case .updateSortType(let sortType):
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
    offset: Int = 0
  ) -> Observable<Mutation> {
    print(offset)
    return Observable.concat([
      Observable.just(.updateIsLoading(true)),
      CVSDatabase.shared.product(
        request: RequestTypeModel(
        cvs: cvs,
        event: event,
        sort: sort),
        offset: offset
      )
      .flatMap { Observable.just(.updateProducts($0)) },
      Observable.just(.updateIsLoading(false)),
      Observable.just(.updateIsLoadingFromCell(false))
    ])
  }
}
