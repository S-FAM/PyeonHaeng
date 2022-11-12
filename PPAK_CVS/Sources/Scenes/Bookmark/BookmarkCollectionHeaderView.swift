import UIKit

import Then
import SnapKit

final class BookmarkCollectionHeaderView: UICollectionReusableView {

  // MARK: - Properties
  static let id = "BookmarkCollectionHeaderView"

  private lazy var mainLabel = UILabel().then {
    $0.text = "찜"
    $0.textColor = .white
    $0.font = .systemFont(ofSize: 32.0, weight: .heavy)
  }

  lazy var infoButton = UIButton().then {
    $0.setImage(UIImage(named: "bookmark_info"), for: .normal)
  }

  lazy var backButton = UIButton().then {
    let image = UIImage(systemName: "chevron.backward")?.applyingSymbolConfiguration(.init(pointSize: 25))
    $0.setImage(image, for: .normal)
    $0.tintColor = .white
  }

  lazy var filterButton = UIButton().then {
    $0.setImage(UIImage(named: "filter"), for: .normal)
  }

  lazy var cvsButton = UIButton().then {
    $0.setImage(UIImage(named: CVSDropdownCase.all.imageName), for: .normal)
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
    [topCurveView, pageControl, searchBar, filterButton, mainLabel, infoButton, cvsButton, backButton]
      .forEach { addSubview($0) }
  }

  private func setupConstraints() {
    topCurveView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    pageControl.snp.makeConstraints { make in
      make.centerY.equalToSuperview().offset(16)
      make.leading.trailing.equalToSuperview().inset(40)
      make.height.equalTo(65)
    }

    searchBar.snp.makeConstraints { make in
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview().inset(32)
      make.trailing.equalTo(filterButton.snp.leading).offset(-16)
      make.height.equalTo(50)
    }

    filterButton.snp.makeConstraints { make in
      make.centerY.equalTo(searchBar)
      make.trailing.equalToSuperview().inset(32)
      make.width.height.equalTo(30)
    }

    mainLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(safeAreaLayoutGuide).inset(8)
    }

    infoButton.snp.makeConstraints { make in
      make.centerY.equalTo(mainLabel)
      make.leading.equalTo(mainLabel.snp.trailing).offset(4)
      make.width.height.equalTo(20)
    }

    backButton.snp.makeConstraints { make in
      make.centerY.equalTo(mainLabel)
      make.leading.equalToSuperview().inset(16)
    }

    cvsButton.snp.makeConstraints { make in
      make.centerY.equalTo(backButton)
      make.trailing.equalToSuperview().inset(16)
      make.width.height.equalTo(40)
    }
  }
}
