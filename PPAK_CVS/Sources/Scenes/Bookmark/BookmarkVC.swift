import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

final class BookmarkViewController: BaseViewController, Viewable {

  // MARK: - Properties

  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.collectionViewLayout = UICollectionViewFlowLayout().then {
      $0.headerReferenceSize = CGSize(width: view.frame.width, height: 320)
      $0.itemSize = CGSize(width: view.frame.width, height: 125)
      $0.sectionInset = UIEdgeInsets(top: 24, left: 0, bottom: 16, right: 0)
    }
    $0.contentInsetAdjustmentBehavior = .never
    $0.bounces = false
    $0.dataSource = self
    $0.delegate = self
    $0.register(
      BookmarkCollectionHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: BookmarkCollectionHeaderView.id
    )
    $0.register(
      GoodsCell.self,
      forCellWithReuseIdentifier: GoodsCell.id
    )
  }

  private lazy var filterDropdownView = FilterDropdownView()
  private lazy var cvsDropdownView = CVSDropdownView()
  private var header: BookmarkCollectionHeaderView!

  // MARK: - Setup

  override func setupStyles() {
    super.setupStyles()
    navigationController?.isNavigationBarHidden = true
    view.backgroundColor = .white
  }

  override func setupLayouts() {
    super.setupLayouts()
    view.addSubview(collectionView)
  }

  override func setupConstraints() {
    collectionView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }

  private func setupDropdown() {
    [filterDropdownView, cvsDropdownView].forEach {
      view.addSubview($0)
      $0.isHidden = true
    }

    filterDropdownView.snp.makeConstraints { make in
      make.top.equalTo(header.filterButton.snp.bottom).offset(12)
      make.trailing.equalToSuperview().inset(16)
      make.width.equalTo(130)
      make.height.equalTo(100)
    }

    cvsDropdownView.snp.makeConstraints { make in
      make.top.equalTo(header.cvsButton.snp.bottom).offset(16)
      make.trailing.equalToSuperview().inset(16)
      make.width.equalTo(64)
      make.height.equalTo(376)
    }
  }

  // MARK: - Bind

  func bind(viewModel: BookmarkViewModel) {}

  private func bindHeader() {
    guard let viewModel = viewModel else { return }

    // MARK: - Action

    // 뒤로 가기 버튼 클릭
    header.backButton.rx.tap
      .map { BookmarkViewModel.Action.backButtonTapped }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 현재 편의점 로고 버튼 클릭
    header.cvsButton.rx.tap
      .map { BookmarkViewModel.Action.currentCVSButtonTapped }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 필터 버튼 클릭
    header.filterButton.rx.tap
      .map { BookmarkViewModel.Action.filterButtonTapped }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 편의점 드롭다운 리스트 버튼 클릭
    cvsDropdownView.buttonEventSubject
      .map { BookmarkViewModel.Action.cvsButtonTappedInDropdown($0) }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 필터 드롭다운 리스트 버튼 클릭
    filterDropdownView.buttonEventSubject
      .map { BookmarkViewModel.Action.filterButtonTappedInDropdown($0) }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 페이지 컨트롤 인덱스 감지
    header.pageControl.pageIndexSubject
      .skip(1)
      .distinctUntilChanged()
      .map { BookmarkViewModel.Action.pageControlIndexEvent($0) }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 빈공간 터치 감지
    view.rx.tapGesture(configuration: { _, delegate in
      delegate.simultaneousRecognitionPolicy = .never
    })
    .map { _ in BookmarkViewModel.Action.backgroundTapped }
    .bind(to: viewModel.action)
    .disposed(by: disposeBag)

    // MARK: - State

    // 편의점 로고 드롭다운 애니메이션 동작
    viewModel.state
      .map { $0.isVisibleCVSDropdown }
      .bind(onNext: { [unowned self] isVisible in
        if isVisible {
          cvsDropdownView.willAppearDropdown()
        } else {
          cvsDropdownView.willDisappearDropdown()
        }
      })
      .disposed(by: disposeBag)

    // 필터 드롭다운 애니메이션 동작
    viewModel.state
      .map { $0.isVisibleFilterDropdown }
      .bind(onNext: { [unowned self] isVisible in
        if isVisible {
          filterDropdownView.willAppearDropdown()
        } else {
          filterDropdownView.willDisappearDropdown()
        }
      })
      .disposed(by: disposeBag)

    // 현재 선택된 편의점 로고 이미지 변경
    viewModel.state
      .map { $0.currentCVSImage.imageName }
      .bind(onNext: { [unowned self] imageName in
        self.header.cvsButton.setImage(UIImage(named: imageName), for: .normal)
      })
      .disposed(by: disposeBag)
  }
}

// MARK: - CollectionView Setup

extension BookmarkViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: GoodsCell.id,
      for: indexPath
    ) as? GoodsCell else {
      return UICollectionViewCell()
    }
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return 10
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    guard let header = collectionView.dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: BookmarkCollectionHeaderView.id,
      for: indexPath
    ) as? BookmarkCollectionHeaderView else {
      return UICollectionReusableView()
    }

    if self.header == nil {
      self.header = header
      bindHeader()
      setupDropdown()
    }

    return header
  }
}
