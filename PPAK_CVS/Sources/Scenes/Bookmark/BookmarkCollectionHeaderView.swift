import UIKit

import Then
import SnapKit

final class BookmarkCollectionHeaderView: UICollectionReusableView {

  // MARK: - Properties
  static let id = "BookmarkCollectionHeaderView"

  private lazy var mainLabel = UILabel().then {
    $0.text = "찜"
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 22.0, weight: .heavy)
  }

  lazy var infoButton = UIButton().then {
    $0.setImage(UIImage(named: "ic_info"), for: .normal)
  }

  lazy var backButton = UIButton().then {
    let image = UIImage(systemName: "chevron.backward")?.applyingSymbolConfiguration(.init(pointSize: 25))
    $0.setImage(image, for: .normal)
    $0.tintColor = .white
  }

  lazy var filterButton = UIButton().then {
    $0.setImage(UIImage(named: "ic_sort"), for: .normal)
  }

  lazy var cvsButton = UIButton().then {
    $0.setImage(CVSType.all.image, for: .normal)
  }

  private lazy var iconContainerView = UIView().then {
    $0.backgroundColor = .clear
  }

  private lazy var infoStack = UIStackView().then { stack in
    [
      mainLabel,
      infoButton
    ]
      .forEach { stack.addArrangedSubview($0) }
    stack.axis  = .horizontal
  }

  lazy var topCurveView = TopCurveView()
  lazy var searchBar = SearchBar()
  lazy var pageControl = PageControl()

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: .zero)
    setupStyles()
    setupLayout()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setup

  private func setupStyles() {
    topCurveView.backgroundColor = CVSType.all.bgColor
    pageControl.focusedView.backgroundColor = CVSType.all.bgColor
  }

  private func setupLayout() {
    [
      topCurveView,
      pageControl,
      searchBar,
      filterButton,
      iconContainerView
    ]
      .forEach { addSubview($0) }

    [
      backButton,
      cvsButton,
      infoStack
    ]
      .forEach { iconContainerView.addSubview($0) }
  }

  private func setupConstraints() {
    topCurveView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    pageControl.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(40)
      make.bottom.equalToSuperview().inset(110)
      make.height.equalTo(65)
    }

    searchBar.snp.makeConstraints { make in
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview().inset(40)
      make.trailing.equalTo(filterButton.snp.leading).offset(-13)
      make.height.equalTo(50)
    }

    filterButton.snp.makeConstraints { make in
      make.centerY.equalTo(searchBar)
      make.trailing.equalToSuperview().inset(16)
      make.width.height.equalTo(44)
    }

    iconContainerView.snp.makeConstraints { make in
      make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
      make.bottom.equalTo(pageControl.snp.top)
    }

    cvsButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().inset(40)
      make.centerY.equalToSuperview()
      make.width.height.equalTo(44)
    }

    infoStack.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }

    backButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(40)
      make.centerY.equalToSuperview()
    }
  }
}
