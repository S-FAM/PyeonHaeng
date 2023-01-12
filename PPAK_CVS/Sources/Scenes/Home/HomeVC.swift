import UIKit

import RxSwift
import RxCocoa
import RxGesture
import RxOptional
import SnapKit
import Then

final class HomeViewController: BaseViewController, Viewable {

  // MARK: - Properties

  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.collectionViewLayout = UICollectionViewFlowLayout()
    $0.contentInsetAdjustmentBehavior = .never
    $0.keyboardDismissMode = .onDrag
    $0.bounces = false
    $0.dataSource = self
    $0.delegate = self
    $0.register(HomeCollectionHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: HomeCollectionHeaderView.id)
    $0.register(GoodsCell.self,
                forCellWithReuseIdentifier: GoodsCell.id)
    $0.register(LoadingCell.self,
                forCellWithReuseIdentifier: LoadingCell.id)
  }

  override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
  private let indicator = UIActivityIndicatorView()
  private let cvsDropdownView = CVSDropdownView()
  private let sortDropdownView = SortDropdownView()
  private var header: HomeCollectionHeaderView!

  // MARK: - Setup

  override func setupLayouts() {
    super.setupLayouts()
    view.addSubview(collectionView)
    view.addSubview(indicator)
  }

  override func setupStyles() {
    navigationController?.isNavigationBarHidden = true
    navigationController?.interactivePopGestureRecognizer?.delegate = nil
    view.backgroundColor = CVSType.all.bgColor
  }

  override func setupConstraints() {
    collectionView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide)
    }

    indicator.snp.makeConstraints { make in
      make.center.equalToSuperview()
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

  // MARK: - Event

  func bind(viewModel: HomeViewModel) {}

  private func bindHeader() {
    guard let viewModel = viewModel else { return }

    // MARK: - Action

    // 화면 최초 실행
    viewModel.action.onNext(.viewDidLoad)

    // 북마크 버튼 클릭
    header.bookmarkButton.rx.tap
      .map { HomeViewModel.Action.didTapBookmarkButton }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 현재 편의점 로고 버튼 클릭
    header.cvsButton.rx.tap
      .map { HomeViewModel.Action.didTapCVSButton }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 필터 버튼 클릭
    header.filterButton.rx.tap
      .map { HomeViewModel.Action.didTapSortButton }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 편의점 드롭다운 리스트 버튼 클릭
    cvsDropdownView.buttonEventSubject
      .map { HomeViewModel.Action.didTapDropdownCVS($0) }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 필터 드롭다운 리스트 버튼 클릭
    sortDropdownView.buttonEventSubject
      .map { HomeViewModel.Action.didTapDropdownSort($0) }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 페이지 컨트롤 인덱스 감지
    header.pageControl.didChangeEvent
      .skip(1)
      .distinctUntilChanged()
      .map { HomeViewModel.Action.didChangeEvent($0) }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 서치바 텍스트 반응
    header.searchBar.textField.rx.controlEvent(.editingDidEndOnExit)
      .withUnretained(self)
      .map { $0.0.header.searchBar.textField.text }
      .filterNil()
      .map { HomeViewModel.Action.didChangeSearchBarText($0) }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // MARK: - State

    // 편의점 로고 드롭다운 애니메이션 동작
    viewModel.state
      .map { $0.isVisibleCVSDropdown }
      .distinctUntilChanged()
      .withUnretained(self)
      .bind { owner, isVisible in
        isVisible ? owner.cvsDropdownView.willAppearDropdown() : owner.cvsDropdownView.willDisappearDropdown()
      }
      .disposed(by: disposeBag)

    // 필터 드롭다운 애니메이션 동작
    viewModel.state
      .map { $0.isVisibleFilterDropdown }
      .distinctUntilChanged()
      .withUnretained(self)
      .bind { owner, isVisible in
        isVisible ? owner.sortDropdownView.willAppearDropdown() : owner.sortDropdownView.willDisappearDropdown()
      }
      .disposed(by: disposeBag)

    // 현재 편의점 타입 반응
    viewModel.state
      .compactMap { $0.currentCVSType }
      .withUnretained(self)
      .bind { owner, cvsType in
        owner.header.cvsButton.setImage(cvsType.image, for: .normal)
        owner.header.topCurveView.backgroundColor = cvsType.bgColor
        owner.header.pageControl.focusedView.backgroundColor = cvsType.bgColor
        owner.view.backgroundColor = cvsType.bgColor
      }
      .disposed(by: disposeBag)

    // 인디케이터 애니메이션 제어
    viewModel.state
      .map { $0.isLoading }
      .bind(to: indicator.rx.isAnimating)
      .disposed(by: disposeBag)

    // 새로운 상품 목록들로 업데이트
    viewModel.state
      .map { $0.products }
      .map { _ in Void() }
      .withUnretained(self)
      .map { $0.0 }
      .bind { $0.collectionView.reloadData() }
      .disposed(by: disposeBag)

    // 현재 SearchBar text
    viewModel.state
      .map { $0.currentTarget }
      .distinctUntilChanged()
      .bind(to: header.searchBar.textField.rx.text)
      .disposed(by: disposeBag)
  }
}

// MARK: - CollectionView Setup

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {

    guard let currentState = viewModel?.currentState else {
      return UICollectionViewCell()
    }

    if indexPath.row != currentState.products.count {
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: GoodsCell.id,
        for: indexPath
      ) as? GoodsCell else {
        return UICollectionViewCell()
      }
      cell.updateCell(currentState.products[indexPath.row])

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

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    guard let products = viewModel?.currentState.products else { return 0 }
    return products.count > 0 ? products.count + 1 : 0
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 24, left: 0, bottom: 16, right: 0)
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
    guard let currentState = viewModel?.currentState else { return CGSize() }

    let width = Int(view.frame.width)
    let height: Int

    if currentState.isBlockedRequest {
      height = indexPath.row == currentState.products.count ? 0 : 125
    } else {
      height = indexPath.row == currentState.products.count ? 40 : 125
    }

    return CGSize(width: width, height: height)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    guard let viewModel = viewModel else { return }

    if indexPath.row == viewModel.currentState.products.count &&
       !viewModel.currentState.isBlockedRequest &&
       !viewModel.currentState.isPagination {
      viewModel.action.onNext(.fetchMoreData)
    }
  }

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
    }

    return header
  }

  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let product = viewModel?.currentState.products[indexPath.row] else { return }

    // 특정 제품 클릭
    viewModel?.action.onNext(.didSelectItemAt(product))
  }

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    cvsDropdownView.willDisappearDropdown()
    sortDropdownView.willDisappearDropdown()
  }
}
