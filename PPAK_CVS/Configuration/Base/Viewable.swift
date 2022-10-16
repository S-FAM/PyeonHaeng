import RxSwift
import WeakMapTable

// Reference: https://github.com/ReactorKit/ReactorKit/blob/master/Sources/ReactorKit/View.swift

private typealias AnyView = AnyObject
private enum MapTables {
  static let viewModel = WeakMapTable<AnyView, Any>()
}

/// A View displays data. A view controller and a cell are treated as a view. The view binds user
/// inputs to the action stream and binds the view states to each UI component. There's no business
/// logic in a view layer. A view just defines how to map the action stream and the state stream.
public protocol Viewable: AnyObject {
  associatedtype ViewModel: PPAK_CVS.ViewModel

  /// A dispose bag. It is disposed each time the `reactor` is assigned.
  var disposeBag: DisposeBag { get set }

  /// A view's reactor. `bind(reactor:)` gets called when the new value is assigned to this property.
  var reactor: ViewModel? { get set }

  /// Creates RxSwift bindings. This method is called each time the `reactor` is assigned.
  ///
  /// Here is a typical implementation example:
  ///
  /// ```
  /// func bind(reactor: MyReactor) {
  ///   // Action
  ///   increaseButton.rx.tap
  ///     .bind(to: Reactor.Action.increase)
  ///     .disposed(by: disposeBag)
  ///
  ///   // State
  ///   reactor.state.map { $0.count }
  ///     .bind(to: countLabel.rx.text)
  ///     .disposed(by: disposeBag)
  /// }
  /// ```
  ///
  /// - warning: It's not recommended to call this method directly.
  func bind(viewModel: ViewModel)
}

// MARK: - Default Implementations

extension Viewable {
  public var viewModel: ViewModel? {
    get { return MapTables.viewModel.value(forKey: self) as? ViewModel }
    set {
      MapTables.viewModel.setValue(newValue, forKey: self)
      self.disposeBag = DisposeBag()
      if let viewModel = newValue {
        self.bind(viewModel: viewModel)
      }
    }
  }
}
