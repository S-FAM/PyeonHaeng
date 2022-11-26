import UIKit

import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then

final class HomeViewController: BaseViewController, Viewable {

  // MARK: - Properties

  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.collectionViewLayout = UICollectionViewFlowLayout().then {
      $0.headerReferenceSize = CGSize(width: self.view.frame.width, height: 320)
      $0.itemSize = CGSize(width: self.view.frame.width, height: 125)
      $0.sectionInset = UIEdgeInsets(top: 24, left: 0, bottom: 16, right: 0)
    }
    $0.contentInsetAdjustmentBehavior = .never
    $0.bounces = false
    $0.dataSource = self
    $0.delegate = self
    $0.register(HomeCollectionHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: HomeCollectionHeaderView.id)
    $0.register(GoodsCell.self,
                forCellWithReuseIdentifier: GoodsCell.id)
  }
  
  private let indicator = UIActivityIndicatorView()
  private let cvsDropdownView = CVSDropdownView()
  private let filterDropdownView = FilterDropdownView()
  private var header: HomeCollectionHeaderView!

  private var products: [ProductModel] = []

  // MARK: - Setup

  override func setupLayouts() {
    super.setupLayouts()
    view.addSubview(collectionView)
    view.addSubview(indicator)
  }

  override func setupStyles() {
    navigationController?.isNavigationBarHidden = true
    navigationController?.interactivePopGestureRecognizer?.delegate = nil
    view.backgroundColor = .white
  }

  override func setupConstraints() {
    collectionView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide)
    }

    indicator.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }

  private func setupDropdown() {
    [cvsDropdownView, filterDropdownView]
      .forEach {
        view.addSubview($0)
        $0.isHidden = true
      }

    cvsDropdownView.snp.makeConstraints { make in
      make.top.equalTo(header.cvsButton.snp.bottom).offset(16)
      make.leading.equalToSuperview().inset(16)
      make.width.equalTo(64)
      make.height.equalTo(376)
    }

    filterDropdownView.snp.makeConstraints { make in
      make.top.equalTo(header.filterButton.snp.bottom).offset(12)
      make.trailing.equalToSuperview().inset(16)
      make.width.equalTo(130)
      make.height.equalTo(100)
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
      .map { HomeViewModel.Action.bookmarkButtonDidTap }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 현재 편의점 로고 버튼 클릭
    header.cvsButton.rx.tap
      .map { HomeViewModel.Action.currentCVSButtonDidTap }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 필터 버튼 클릭
    header.filterButton.rx.tap
      .map { HomeViewModel.Action.filterButtonDidTap }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 편의점 드롭다운 리스트 버튼 클릭
    cvsDropdownView.buttonEventSubject
      .map { HomeViewModel.Action.dropdownCVSButtonDidTap($0) }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 필터 드롭다운 리스트 버튼 클릭
    filterDropdownView.buttonEventSubject
      .map { HomeViewModel.Action.dropdownFilterButtonDidTap($0) }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 페이지 컨트롤 인덱스 감지
    header.pageControl.pageIndexSubject
      .skip(1)
      .distinctUntilChanged()
      .map { HomeViewModel.Action.pageControlIndexDidChange($0) }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 빈공간 터치 감지
    view.rx.tapGesture(configuration: { _, delegate in
      delegate.simultaneousRecognitionPolicy = .never
    })
    .map { _ in HomeViewModel.Action.backgroundDidTap }
    .bind(to: viewModel.action)
    .disposed(by: disposeBag)

    // MARK: - State

    // 편의점 로고 드롭다운 애니메이션 동작
    viewModel.state
      .map { $0.isVisibleCVSDropdown }
      .withUnretained(self)
      .bind(onNext: { owner, isVisible in
        isVisible ? owner.cvsDropdownView.willAppearDropdown() : owner.cvsDropdownView.willDisappearDropdown()
      })
      .disposed(by: disposeBag)

    // 필터 드롭다운 애니메이션 동작
    viewModel.state
      .map { $0.isVisibleFilterDropdown }
      .withUnretained(self)
      .bind(onNext: { owner, isVisible in
        isVisible ? owner.filterDropdownView.willAppearDropdown() : owner.filterDropdownView.willDisappearDropdown()
      })
      .disposed(by: disposeBag)

    // 현재 편의점 타입 반응
    viewModel.state
      .compactMap { $0.currentCVSType }
      .withUnretained(self)
      .bind(onNext: { owner, cvsType in
        owner.header.cvsButton.setImage(cvsType.image, for: .normal)
        owner.header.topCurveView.backgroundColor = cvsType.bgColor
        owner.header.pageControl.focusedView.backgroundColor = cvsType.bgColor
      })
      .disposed(by: disposeBag)

    // 인디케이터 애니메이션 제어
    viewModel.state
      .map { $0.indicatorState }
      .bind(to: indicator.rx.isAnimating)
      .disposed(by: disposeBag)

    // 새로운 상품 목록들로 업데이트
    viewModel.state
      .map { $0.products }
      .map { _ in Void() }
      .withUnretained(self)
      .map { $0.0 }
      .bind(onNext: { $0.collectionView.reloadData() })
      .disposed(by: disposeBag)
  }
}

// MARK: - CollectionView Setup

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: GoodsCell.id,
      for: indexPath
    ) as? GoodsCell,
          let product = viewModel?.currentState.products[indexPath.row] else {
      return UICollectionViewCell()
    }
    cell.updateCell(product)
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    guard let products = viewModel?.currentState.products else { return 0 }
    return products.count
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
}
