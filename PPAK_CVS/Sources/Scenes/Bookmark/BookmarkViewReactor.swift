import ReactorKit
import RxSwift

final class BookmarkViewReactor: Reactor {

  enum Action {
    case viewDidLoad
    case didTapCVSButton
    case didTapSortButton
    case didTapBackButton
    case didTapBackground
    case didChangeEvent(EventType)
    case didTapDropdownCVS(CVSDropdownCase)
    case didTapDropdownSort(SortType)
    case didChangeSearchBarText(String)
  }

  enum Mutation {
    case setCVSDropdown
    case setSortDropdown
    case setHomeVC(Bool)
    case setSettingVC(Bool)
    case hideDropdown
    case hideKeyboard(Bool)
    case setCVS(CVSType)
    case setSort(SortType)
    case setEvent(EventType)
    case setTarget(String)
    case setProducts([ProductModel])
  }

  struct State {
    var isHiddenCVSDropdown: Bool = true
    var isHiddenSortDropdown: Bool = true
    var isHiddenAnimationView: Bool = false
    var showsKeyboard: Bool = false
    var showsHomeVC: Bool = false
    var showsSettingVC: Bool = false
    var currentSort: SortType = .ascending
    var currentCVS: CVSType = CVSStorage.shared.cvs
    var currentEvent: EventType = .all
    var currentTarget: String = ""
    var currentProducts: [ProductModel] = []
  }

  var initialState = State()

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      let products = ProductStorage.shared.retrieve(cvs: currentState.currentCVS)
      return .just(.setProducts(products))

    case .didTapCVSButton:
      return .just(.setCVSDropdown)

    case .didTapSortButton:
      return .just(.setSortDropdown)

    case .didTapBackButton:
      return .concat([
        .just(.setHomeVC(true)),
        .just(.setHomeVC(false))
      ])

    case .didTapBackground:
      return .concat([
        .just(.hideDropdown),
        .just(.hideKeyboard(true)),
        .just(.hideKeyboard(false))
      ])

    case .didChangeEvent(let event):

      let updatedProducts = ProductStorage.shared.retrieve(
        cvs: currentState.currentCVS,
        event: event,
        sort: .none,
        target: currentState.currentTarget
      )

      return .concat([
        .just(.setEvent(event)),
        .just(.hideDropdown),
        .just(.setProducts(updatedProducts))
      ])

    case .didTapDropdownCVS(let cvsDropdownCase):

      switch cvsDropdownCase {
      case .cvs(let cvs):
        CVSStorage.shared.save(cvs)
        CVSStorage.shared.didChangeCVS.onNext(cvs)

        let updatedProducts = ProductStorage.shared.retrieve(
          cvs: cvs,
          event: currentState.currentEvent,
          sort: .none)

        return .concat([
          .just(.setCVS(cvs)),
          .just(.hideDropdown),
          .just(.setTarget("")),
          .just(.setProducts(updatedProducts))
        ])

      case .setting:
        return .concat([
          .just(.hideDropdown),
          .just(.setSettingVC(true)),
          .just(.setSettingVC(false))
        ])
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
        .just(.setProducts(updatedProducts))
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
        .just(.setProducts(updatedProducts))
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

    case .setSettingVC(let state):
      nextState.showsSettingVC = state

    case .hideDropdown:
      nextState.isHiddenSortDropdown = true
      nextState.isHiddenCVSDropdown = true

    case .hideKeyboard(let state):
      nextState.showsKeyboard = state

    case .setCVS(let cvsType):
      nextState.currentCVS = cvsType

    case .setSort(let filterDropdownCase):
      nextState.currentSort = filterDropdownCase

    case .setEvent(let event):
      nextState.currentEvent = event

    case .setTarget(let text):
      nextState.currentTarget = text

    case .setProducts(let products):
      if products.isEmpty {
        nextState.isHiddenAnimationView = false
      } else {
        nextState.isHiddenAnimationView = true
      }

      nextState.currentProducts = products
    }
    return nextState
  }
}
