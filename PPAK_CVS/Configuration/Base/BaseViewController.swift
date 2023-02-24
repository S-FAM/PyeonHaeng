import UIKit.UIViewController

import class RxSwift.DisposeBag

class BaseViewController: UIViewController {

  /// A dispose bag. 각 ViewController에 종속적이다.
  final var disposeBag = DisposeBag()

  /// A coordinator used to navigate`ViewControllers`
  weak var coordinator: Coordinator?

  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayouts()
    setupConstraints()
    setupStyles()
    navigationController?.interactivePopGestureRecognizer?.delegate = self
  }

  /// UI 프로퍼티를 view에 할당합니다.
  ///
  /// ```
  /// func setupLayouts() {
  ///   self.view.addSubview(label)
  ///   self.stackView.addArrangedSubview(label)
  ///   self.label.layer.addSubLayer(gradientLayer)
  ///   // codes..
  /// }
  /// ```
  func setupLayouts() { }

  /// UI 프로퍼티의 제약조건을 설정합니다.
  ///
  /// ```
  /// func setupConstraints() {
  ///   // with SnapKit
  ///   label.snp.makeConstraints { make in
  ///     make.edges.equalToSuperview()
  ///   }
  ///   // codes..
  /// }
  /// ```
  func setupConstraints() { }

  /// View와 관련된 Style을 설정합니다.
  ///
  /// ```
  /// func setupStyles() {
  ///   navigationController?.navigationBar.tintColor = .white
  ///   view.backgroundColor = .white
  ///   // codes..
  /// }
  /// ```
  func setupStyles() {
    view.backgroundColor = .systemBackground
  }
}

extension BaseViewController: UIGestureRecognizerDelegate {
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return navigationController?.viewControllers.count ?? 0 > 1
  }
}
