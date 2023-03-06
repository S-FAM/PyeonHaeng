import ReactorKit
import RxSwift
import RxCocoa

final class HomeViewReactor: Reactor {

  enum Action {
    case viewDidLoad
    case didTapBackground
    case didTapCVSButton
    case didTapSortButton
    case didTapBookmarkButton
    case didChangeEvent(EventType)
    case didTapDropdownCVS(CVSDropdownCase)
    case didTapDropdownSort(SortType)
    case didChangeSearchBarText(String)
    case didTapSearchButton
    case didSelectItemAt(ProductModel)
    case fetchMoreData
  }

  enum Mutation {
    case setCVSDropdown(Bool)
    case setFilterDropdown(Bool)
    case setBookmarkVC(Bool)
    case hideDropdown
    case hideKeyboard(Bool)
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
    case setProductVC(Bool, ProductModel)
    case setSettingVC(Bool)
  }

  struct State {
    var isVisibleCVSDropdown: Bool = false
    var isVisibleFilterDropdown: Bool = false
    var showsKeyboard: Bool = false
    var showsBookmarkVC: (Bool, CVSType) = (false, .all)
    var showsProductVC: (Bool, ProductModel) = (false, .init(
      imageLink: nil,
      name: "",
      dateString: "",
      price: 0,
      store: .all,
      saleType: .all
    ))
    var showsSettingVC: Bool = false
    var currentSortType: SortType = .none
    var currentEventType: EventType = .all
    var currentCVSType: CVSType = CVSStorage.shared.favoriteCVS
    var currentTarget: String = ""
    var isLoading: Bool = false
    var isBlockedRequest: Bool = false
    var isPagination: Bool = false
    var products: [ProductModel] = []
    var currentOffset: Int = 0
  }

  var initialState = State()

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let cvs = CVSStorage.shared.didChangeCVS
    return .merge(mutation, cvs.map { Mutation.setCVS($0) })
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return requestProducts(cvs: currentState.currentCVSType, event: .all, sort: .none)

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
      ])

    case .didTapBackground:
      return .concat([
        .just(.hideDropdown),
        .just(.hideKeyboard(true)),
        .just(.hideKeyboard(false))
      ])

    case .didTapCVSButton:
      let isVisible = currentState.isVisibleCVSDropdown
      return .concat([
        .just(.setCVSDropdown(!isVisible)),
        .just(.setFilterDropdown(false))
      ])

    case .didTapSortButton:
      let isVisible = currentState.isVisibleFilterDropdown
      return .concat([
        .just(.setFilterDropdown(!isVisible)),
        .just(.setCVSDropdown(false))
      ])

    case .didTapBookmarkButton:
      return .concat([
        .just(.hideDropdown),
        .just(.setBookmarkVC(true)),
        .just(.setBookmarkVC(false))
      ])

    case .didChangeEvent(let event):
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

    case .didTapDropdownCVS(let cvsDropdownCase):
      switch cvsDropdownCase {
      case .cvs(let cvsType):
        CVSStorage.shared.save(cvsType)

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
        return .concat([
          .just(.hideDropdown),
          .just(.setSettingVC(true)),
          .just(.setSettingVC(false))
        ])
      }

    case .didTapDropdownSort(let sortType):
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

    case .didChangeSearchBarText(let target):
      return .just(.setTarget(target))

    case .didTapSearchButton:
      return .concat([
        .just(.setLoading(true)),
        .just(.resetProducts),
        .just(.resetOffset),
        .just(.hideDropdown),
        requestProducts(
          cvs: currentState.currentCVSType,
          event: currentState.currentEventType,
          sort: currentState.currentSortType,
          name: currentState.currentTarget
        )
      ])

    case .didSelectItemAt(let product):
      return .concat([
        .just(.setProductVC(true, product)),
        .just(.setProductVC(false, product))
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

    case .hideKeyboard(let state):
      nextState.showsKeyboard = state

    case .hideDropdown:
      nextState.isVisibleFilterDropdown = false
      nextState.isVisibleCVSDropdown = false

    case let .setBookmarkVC(isShowBookmarkVC):
      nextState.showsBookmarkVC = (isShowBookmarkVC, currentState.currentCVSType)

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

    case let .setProductVC(state, product):
      nextState.showsProductVC = (state, product)

    case .setSettingVC(let state):
      nextState.showsSettingVC = state
    }
    return nextState
  }
}

extension HomeViewReactor {
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
