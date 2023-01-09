import UIKit

import Then
import SnapKit

final class BookmarkCollectionHeaderView: UICollectionReusableView {

  // MARK: - Properties
  static let id = "BookmarkCollectionHeaderView"

  private let mainLabel = UILabel().then {
    $0.text = "찜"
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 22.0, weight: .heavy)
  }

  private let infoButton = UIButton().then {
    $0.setImage(UIImage(named: "ic_info"), for: .normal)
  }

  let backButton = UIButton().then {
    $0.setImage(UIImage(named: "ic_back_white"), for: .normal)
  }

  let filterButton = UIButton().then {
    $0.setImage(UIImage(named: "ic_sort"), for: .normal)
  }

  let cvsButton = UIButton().then {
    $0.setImage(CVSType.all.image, for: .normal)
  }

  private let iconContainerView = UIView().then {
    $0.backgroundColor = .clear
  }

  let infoStack = UIStackView()
  let infoTouchView = UIView()
  let topCurveView = TopCurveView()
  let searchBar = SearchBar()
  let pageControl = EventControl()

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
      iconContainerView,
      infoTouchView
    ].forEach { addSubview($0) }

    [
      backButton,
      cvsButton,
      infoStack
    ].forEach { iconContainerView.addSubview($0) }

    [
      mainLabel,
      infoButton
    ].forEach { infoStack.addArrangedSubview($0) }
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
      make.leading.equalToSuperview().inset(25)
      make.width.height.equalTo(44)
      make.centerY.equalToSuperview()
    }

    infoTouchView.snp.makeConstraints { make in
      make.center.equalTo(infoStack)
      make.width.height.equalTo(44)
    }
  }
}
