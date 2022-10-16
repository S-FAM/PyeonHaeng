import RxSwift
import WeakMapTable

// Reference: https://github.com/ReactorKit/ReactorKit/blob/master/Sources/ReactorKit/Reactor.swift
public protocol ViewModel: AnyObject {

  associatedtype Action

  associatedtype Mutation = Action

  associatedtype State

  typealias Scheduler = ImmediateSchedulerType

  /// The action from the view. Bind user inputs to this subject.
  var action: PublishSubject<Action> { get }

  /// The initial state.
  var initialState: State { get }

  /// The current state. This value is changed just after the state stream emits a new state.
  var currentState: State { get }

  /// The state stream. Use this observable to observe the state changes.
  var state: Observable<State> { get }

  /// A scheduler for observing the state stream. Defaults to `MainScheduler`.
  var scheduler: Scheduler { get }

  /// Transforms the action. Use this function to combine with other observables. This method is
  /// called once before the state stream is created.
  func transform(action: Observable<Action>) -> Observable<Action>

  /// Commits mutation from the action. This is the best place to perform side-effects such as
  /// async tasks.
  func mutate(action: Action) -> Observable<Mutation>

  /// Transforms the mutation stream. Implement this method to transform or combine with other
  /// observables. This method is called once before the state stream is created.
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation>

  /// Generates a new state with the previous state and the action. It should be purely functional
  /// so it should not perform any side-effects here. This method is called every time when the
  /// mutation is committed.
  func reduce(state: State, mutation: Mutation) -> State

  /// Transforms the state stream. Use this function to perform side-effects such as logging. This
  /// method is called once after the state stream is created.
  func transform(state: Observable<State>) -> Observable<State>
}

// MARK: - Map Tables

private typealias AnyViewModel = AnyObject

private enum MapTables {
  static let action = WeakMapTable<AnyViewModel, AnyObject>()
  static let currentState = WeakMapTable<AnyViewModel, Any>()
  static let state = WeakMapTable<AnyViewModel, AnyObject>()
  static let disposeBag = WeakMapTable<AnyViewModel, DisposeBag>()
}

// MARK: - Default Implementations

extension ViewModel {

  public var action: PublishSubject<Action> {
    // Creates a state stream automatically
    _ = self.state

    return MapTables.action.forceCastedValue(forKey: self, default: .init())
  }

  public internal(set) var currentState: State {
    get { return MapTables.currentState.forceCastedValue(forKey: self, default: self.initialState) }
    set { MapTables.currentState.setValue(newValue, forKey: self) }
  }

  public var state: Observable<State> {
    return MapTables.state.forceCastedValue(forKey: self, default: self.createStateStream())
  }

  public var scheduler: Scheduler {
    return MainScheduler.instance
  }

  private var disposeBag: DisposeBag {
    return MapTables.disposeBag.value(forKey: self, default: DisposeBag())
  }

  public func createStateStream() -> Observable<State> {
    let action = self.action.asObservable()
    let transformedAction = self.transform(action: action)
    let mutation = transformedAction
      .flatMap { [weak self] action -> Observable<Mutation> in
        guard let self = self else { return .empty() }
        return self.mutate(action: action).catch { _ in .empty() }
      }
    let transformedMutation = self.transform(mutation: mutation)
    let state = transformedMutation
      .scan(self.initialState) { [weak self] state, mutation -> State in
        guard let self = self else { return state }
        return self.reduce(state: state, mutation: mutation)
      }
      .catch { _ in .empty() }
      .startWith(self.initialState)
    let transformedState = self.transform(state: state)
      .do(onNext: { [weak self] state in
        self?.currentState = state
      })
      .replay(1)
    transformedState.connect().disposed(by: self.disposeBag)
    return transformedState.observe(on: self.scheduler)
  }

  public func transform(action: Observable<Action>) -> Observable<Action> {
    return action
  }

  public func mutate(action: Action) -> Observable<Mutation> {
    return .empty()
  }

  public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return mutation
  }

  public func reduce(state: State, mutation: Mutation) -> State {
    return state
  }

  public func transform(state: Observable<State>) -> Observable<State> {
    return state
  }
}

extension ViewModel where Action == Mutation {
  public func mutate(action: Action) -> Observable<Mutation> {
    return .just(action)
  }
}
