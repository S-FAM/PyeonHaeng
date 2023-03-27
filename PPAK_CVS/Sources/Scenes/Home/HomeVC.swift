import UIKit

import ReactorKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import SkeletonView
import Then
import Lottie

final class HomeViewController: BaseViewController, View {

  // MARK: - Properties

  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.collectionViewLayout = UICollectionViewFlowLayout()
    $0.contentInsetAdjustmentBehavior = .never
    $0.keyboardDismissMode = .onDrag
    $0.bounces = false
    $0.isSkeletonable = true
    $0.dataSource = self
    $0.delegate = self
    $0.register(
      HomeCollectionHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: HomeCollectionHeaderView.id)
    $0.register(
      GoodsCell.self,
      forCellWithReuseIdentifier: GoodsCell.id)
    $0.register(
      LoadingCell.self,
      forCellWithReuseIdentifier: LoadingCell.id)
  }

  private let animationContainerView = UIView().then {
    $0.backgroundColor = .clear
  }

  private let animationView = LottieAnimationView(name: "noBookmark").then {
    $0.contentMode = .scaleAspectFill
    $0.loopMode = .loop
  }

  private let noBookmarkLabel = UILabel().then {
    $0.textColor = .lightGray
    $0.font = .appFont(family: .regular, size: 15)
    $0.text = "해당하는 상품이 없습니다."
  }

  override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
  private let cvsDropdownView = CVSDropdownView()
  private let sortDropdownView = SortDropdownView()
  private var header: HomeCollectionHeaderView!

  // MARK: - LIFE CYCLE

  override func viewDidLoad() {
    super.viewDidLoad()
    reactor?.action.onNext(.viewDidLoad)
  }

  // MARK: - Setup

  override func setupLayouts() {
    super.setupLayouts()
    view.addSubview(collectionView)

  }

  override func setupStyles() {
    super.setupStyles()
    navigationController?.setNavigationBarHidden(true, animated: true)
    view.backgroundColor = CVSType.all.bgColor
    view.isSkeletonable = true
  }

  override func setupConstraints() {
    collectionView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide)
    }
  }

  private func setupDropdown() {
    [
      cvsDropdownView,
      sortDropdownView
    ].forEach {
      view.addSubview($0)
      $0.isHidden = true
    }

    cvsDropdownView.snp.makeConstraints { make in
      make.top.equalTo(header.cvsButton.snp.bottom).offset(10)
      make.centerX.equalTo(header.cvsButton)
      make.width.equalTo(73)
      make.height.equalTo(450)
    }

    sortDropdownView.snp.makeConstraints { make in
      make.top.equalTo(header.filterButton.snp.bottom).offset(12)
      make.trailing.equalToSuperview().inset(16)
      make.width.equalTo(100)
      make.height.equalTo(80)
    }
  }

  private func setupAnimationView() {
    let stack = UIStackView(arrangedSubviews: [
      animationView,
      noBookmarkLabel
    ])
    stack.axis = .vertical
    stack.spacing = 40
    stack.alignment = .center
    self.animationContainerView.addSubview(stack)

    stack.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }

//    self.animationContainerView.snp.makeConstraints { make in
//      make.leading.trailing.bottom.equalTo(collectionView)
//      make.bottom.equalTo(collectionView.snp.bottom).inset(165)
//    }

//    self.animationView.snp.makeConstraints { make in
//      make.width.equalTo(165)
//      make.height.equalTo(107)
//    }
//
//    self.animationView.play()
  }

  // MARK: - Event

  func bind(reactor: HomeViewReactor) {}

  private func bindHeader() {
    guard let reactor = reactor else { return }

    // MARK: - Action

    // 북마크 버튼 클릭
    header.bookmarkButton.rx.tap
      .map { HomeViewReactor.Action.didTapBookmarkButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // 현재 편의점 로고 버튼 클릭
    header.cvsButton.rx.tap
      .map { HomeViewReactor.Action.didTapCVSButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // 필터 버튼 클릭
    header.filterButton.rx.tap
      .map { HomeViewReactor.Action.didTapSortButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // 편의점 드롭다운 리스트 버튼 클릭
    cvsDropdownView.cvsSwitch
      .map { HomeViewReactor.Action.didTapDropdownCVS($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // 필터 드롭다운 리스트 버튼 클릭
    sortDropdownView.sortSwitch
      .map { HomeViewReactor.Action.didTapDropdownSort($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // 페이지 컨트롤 인덱스 감지
    header.pageControl.didChangeEvent
      .skip(1)
      .distinctUntilChanged()
      .map { HomeViewReactor.Action.didChangeEvent($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // 서치바 텍스트 반응
    header.searchBar.textField.rx.text
      .orEmpty
      .map { HomeViewReactor.Action.didChangeSearchBarText($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // 검색 버튼 반응
    header.searchBar.textField.rx.controlEvent(.editingDidEndOnExit)
      .map { HomeViewReactor.Action.didTapSearchButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // CVSStorage 편의점 변경 감지
    CVSStorage.shared.didChangeCVS
      .distinctUntilChanged()
      .map { HomeViewReactor.Action.didTapDropdownCVS(.cvs($0)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // 백그라운드 터치
    view.rx.tapGesture { gesture, delegate in
      gesture.cancelsTouchesInView = false
      delegate.beginPolicy = .custom { [weak self] gesture in
        guard let self = self else { return false }

        let hitView = self.view.hitTest(gesture.location(in: self.view), with: .none)

        if hitView === self.header.cvsButton ||
           hitView === self.header.filterButton ||
           hitView === self.header.searchBar.textField ||
           self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) != nil {
          return false
        } else {
          return true
        }
      }
    }
    .map { _ in HomeViewReactor.Action.didTapBackground }
    .bind(to: reactor.action)
    .disposed(by: disposeBag)

    // MARK: - State

    // 편의점 로고 드롭다운 애니메이션 동작
    reactor.state
      .map { $0.isVisibleCVSDropdown }
      .distinctUntilChanged()
      .withUnretained(self)
      .bind { owner, isVisible in
        isVisible ? owner.cvsDropdownView.showDropdown() : owner.cvsDropdownView.hideDropdown()
      }
      .disposed(by: disposeBag)

    // 필터 드롭다운 애니메이션 동작
    reactor.state
      .map { $0.isVisibleFilterDropdown }
      .distinctUntilChanged()
      .withUnretained(self)
      .bind { owner, isVisible in
        isVisible ? owner.sortDropdownView.showDropdown() : owner.sortDropdownView.hideDropdown()
      }
      .disposed(by: disposeBag)

    // 현재 편의점 타입 반응
    reactor.state
      .compactMap { $0.currentCVSType }
      .withUnretained(self)
      .bind { owner, cvsType in
        owner.header.appIconImageView.tintColor = cvsType.fontColor
        owner.header.cvsButton.setImage(cvsType.image, for: .normal)
        owner.header.topCurveView.tintColor = cvsType.bgColor
        owner.header.pageControl.focusedView.backgroundColor = cvsType.bgColor
        owner.header.pageControl.labels.forEach { $0.textColor = cvsType.fontColor }
        owner.view.backgroundColor = cvsType.bgColor
      }
      .disposed(by: disposeBag)

    // 스켈레톤뷰 애니메이션 제어
    reactor.state
      .map { $0.isSkeletonActive }
      .distinctUntilChanged()
      .bind(with: self) { owner, isLoading in
        let skeletetonAnimation = SkeletonAnimationBuilder()
          .makeSlidingAnimation(withDirection: .leftRight)

        if isLoading {
          owner.view.showAnimatedGradientSkeleton(
            usingGradient: .init(baseColor: .systemGray6),
            animation: skeletetonAnimation,
            transition: .none
          )
        } else {
          owner.view.hideSkeleton()
        }
      }
      .disposed(by: disposeBag)

    // ReloadData
    reactor.state
      .map { $0.reloadData }
      .filter { $0 }
      .withUnretained(self)
      .bind { $0.0.collectionView.reloadData() }
      .disposed(by: disposeBag)

    // 현재 SearchBar text
    reactor.state
      .map { $0.currentTarget }
      .distinctUntilChanged()
      .bind(to: header.searchBar.textField.rx.text)
      .disposed(by: disposeBag)

    // 키보드 숨김
    reactor.state
      .map { $0.showsKeyboard }
      .filter { $0 }
      .withUnretained(self)
      .bind { owner, _ in owner.view.endEditing(true) }
      .disposed(by: disposeBag)
  }
}

// MARK: - COLLECTIONVIEW DATASOURCE

extension HomeViewController: SkeletonCollectionViewDataSource {

  // MARK: - SKELETONVIEW SETUP

  func collectionSkeletonView(
    _ skeletonView: UICollectionView,
    cellIdentifierForItemAt indexPath: IndexPath
  ) -> SkeletonView.ReusableCellIdentifier {
    return GoodsCell.id
  }

  func collectionSkeletonView(
    _ skeletonView: UICollectionView,
    supplementaryViewIdentifierOfKind: String,
    at indexPath: IndexPath
  ) -> ReusableCellIdentifier? {
    return HomeCollectionHeaderView.id
  }

  func collectionSkeletonView(
    _ skeletonView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return 20
  }

  // Cell 생성
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {

    guard let currentState = reactor?.currentState else {
      return UICollectionViewCell()
    }

    if indexPath.row != currentState.products.count {
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: GoodsCell.id,
        for: indexPath
      ) as? GoodsCell else {
        return UICollectionViewCell()
      }

      cell.updateCell(
        currentState.products[indexPath.row],
        isShowTitleLogoView: true
      )

      return cell
    } else {
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: LoadingCell.id,
        for: indexPath
      ) as? LoadingCell else {
        return UICollectionViewCell()
      }

      if currentState.isBlockedRequest {
        cell.indicator.stopAnimating()
      } else {
        cell.indicator.startAnimating()
      }

      return cell
    }
  }

  // 셀 갯수
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    guard let products = reactor?.currentState.products else { return 0 }
    return products.count > 0 ? products.count + 1 : 0
  }

  // 헤더 생성
  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    guard let header = collectionView.dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: HomeCollectionHeaderView.id,
      for: indexPath
    ) as? HomeCollectionHeaderView else { return UICollectionReusableView() }

    if self.header == nil {
      self.header = header
      bindHeader()
      setupDropdown()
      setupAnimationView()
    }

    return header
  }

  // 스크롤 감지
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    cvsDropdownView.hideDropdown()
    sortDropdownView.hideDropdown()
  }
}

// MARK: - COLLECTIONVIEW FLOW LAYOUT

extension HomeViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    return CGSize(width: view.frame.width, height: 280)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    guard let currentState = reactor?.currentState else { return CGSize() }

    let width = Int(view.frame.width)
    let height: Int

    if currentState.isBlockedRequest {
      height = indexPath.row == currentState.products.count ? 0 : 125
    } else {
      height = indexPath.row == currentState.products.count ? 40 : 125
    }

    if currentState.isSkeletonActive {
      return CGSize(width: width, height: 125)
    } else {
      return CGSize(width: width, height: height)
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    guard let reactor = reactor else { return }

    if indexPath.row == reactor.currentState.products.count - 5 &&
       !reactor.currentState.isBlockedRequest &&
       !reactor.currentState.isPagination {
      reactor.action.onNext(.fetchMoreData)
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let product = reactor?.currentState.products[indexPath.row] else { return }

    // 특정 제품 클릭
    reactor?.action.onNext(.didSelectItemAt(product))
  }
}
