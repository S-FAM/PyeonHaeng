import RxSwift

final class BookmarkViewModel: ViewModel {

  enum Action {
    case didTapCVSButton
    case didTapSortButton
    case didTapBackButton
    case didChangeEvent(EventType)
    case didTapDropdownCVS(CVSDropdownCase)
    case didTapDropdownSort(SortType)
    case didChangeSearchBarText(String)
  }

  enum Mutation {
    case setCVSDropdown
    case setSortDropdown
    case setHomeVC(Bool)
    case hideDropdown
    case setCVS(CVSType)
    case setSort(SortType)
    case setEvent(EventType)
    case setTarget(String)
    case setLoading(Bool)
    case setProducts([ProductModel])
  }

  struct State {
    var isHiddenCVSDropdown: Bool = true
    var isHiddenSortDropdown: Bool = true
    var showsHomeVC: Bool = false
    var currentSort: SortType = .ascending
    var currentCVS: CVSType = .all
    var currentEvent: EventType = .all
    var currentTarget: String = ""
    var isLoading: Bool = false
    var currentProducts: [ProductModel] = ProductStorage.shared.products
  }

  var initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapCVSButton:
      return .just(.setCVSDropdown)

    case .didTapSortButton:
      return .just(.setSortDropdown)

    case .didTapBackButton:
      return .concat([
        .just(.setHomeVC(true)),
        .just(.setHomeVC(false))
      ])

    case .didChangeEvent(let event):

      let updatedProducts = ProductStorage.shared.retrieve(
        cvs: currentState.currentCVS,
        event: event,
        sort: .none,
        target: currentState.currentTarget)

      return .concat([
        .just(.setEvent(event)),
        .just(.hideDropdown),
        .just(.setLoading(true)),
        .just(.setProducts([])).delay(.milliseconds(100), scheduler: MainScheduler.asyncInstance),
        .just(.setProducts(updatedProducts)),
        .just(.setLoading(false))
      ])

    case .didTapDropdownCVS(let cvsDropdownCase):

      switch cvsDropdownCase {
      case .cvs(let cvs):

        let updatedProducts = ProductStorage.shared.retrieve(
          cvs: cvs,
          event: currentState.currentEvent,
          sort: .none)

        return .concat([
          .just(.setCVS(cvs)),
          .just(.hideDropdown),
          .just(.setTarget("")),
          .just(.setLoading(true)),
          .just(.setProducts([])).delay(.milliseconds(100), scheduler: MainScheduler.asyncInstance),
          .just(.setProducts(updatedProducts)),
          .just(.setLoading(false))
        ])

      case .setting:
        return .empty()
      }

    case .didChangeSearchBarText(let target):

      let updatedProducts = ProductStorage.shared.retrieve(
        cvs: currentState.currentCVS,
        event: currentState.currentEvent,
        sort: currentState.currentSort,
        target: target
      )

      return .concat([
        .just(.setTarget(target)),
        .just(.hideDropdown),
        .just(.setLoading(true)),
        .just(.setProducts([])).delay(.milliseconds(100), scheduler: MainScheduler.asyncInstance),
        .just(.setProducts(updatedProducts)),
        .just(.setLoading(false))
      ])

    case .didTapDropdownSort(let sort):

      let updatedProducts = ProductStorage.shared.retrieve(
        cvs: currentState.currentCVS,
        event: currentState.currentEvent,
        sort: sort,
        target: currentState.currentTarget
      )

      return .concat([
        .just(.setSort(sort)),
        .just(.hideDropdown),
        .just(.setLoading(true)),
        .just(.setProducts([])).delay(.milliseconds(100), scheduler: MainScheduler.asyncInstance),
        .just(.setProducts(updatedProducts)),
        .just(.setLoading(false))
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var nextState = state

    switch mutation {
    case .setCVSDropdown:
      nextState.isHiddenCVSDropdown.toggle()
      nextState.isHiddenSortDropdown = true

    case .setSortDropdown:
      nextState.isHiddenSortDropdown.toggle()
      nextState.isHiddenCVSDropdown = true

    case .setHomeVC(let state):
      nextState.showsHomeVC = state

    case .hideDropdown:
      nextState.isHiddenSortDropdown = true
      nextState.isHiddenCVSDropdown = true

    case .setCVS(let cvsType):
      nextState.currentCVS = cvsType

    case .setSort(let filterDropdownCase):
      nextState.currentSort = filterDropdownCase

    case .setEvent(let event):
      nextState.currentEvent = event

    case .setTarget(let text):
      nextState.currentTarget = text

    case .setLoading(let isLoading):
      nextState.isLoading = isLoading

    case .setProducts(let products):
      nextState.currentProducts = products
    }
    return nextState
  }
}
