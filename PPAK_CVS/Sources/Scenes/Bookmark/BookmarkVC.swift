import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

final class BookmarkViewController: BaseViewController, Viewable {

  // MARK: - Properties

  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
    $0.collectionViewLayout = UICollectionViewFlowLayout()
    $0.contentInsetAdjustmentBehavior = .never
    $0.bounces = false
    $0.keyboardDismissMode = .onDrag
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

  private lazy var sortDropdownView = SortDropdownView()
  private lazy var cvsDropdownView = CVSDropdownView()
  private var header: BookmarkCollectionHeaderView!
  private let storage = Storage.shared

  // MARK: - Setup

  override func setupStyles() {
    super.setupStyles()
    navigationController?.isNavigationBarHidden = true
    view.backgroundColor = CVSType.all.bgColor
  }

  override func setupLayouts() {
    super.setupLayouts()
    view.addSubview(collectionView)
  }

  override func setupConstraints() {
    collectionView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide)
    }
  }

  private func setupDropdown() {
    [
      sortDropdownView,
      cvsDropdownView
    ]
      .forEach {
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

  // MARK: - Bind

  func bind(viewModel: BookmarkViewModel) {}

  private func bindHeader() {
    guard let viewModel = viewModel else { return }

    // MARK: - Action

    // 뒤로 가기 버튼 클릭
    header.backButton.rx.tap
      .map { BookmarkViewModel.Action.didTapBackButton }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 현재 편의점 로고 버튼 클릭
    header.cvsButton.rx.tap
      .map { BookmarkViewModel.Action.didTapCVSButton }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 필터 버튼 클릭
    header.filterButton.rx.tap
      .map { BookmarkViewModel.Action.didTapSortButton }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 편의점 드롭다운 리스트 버튼 클릭
    cvsDropdownView.buttonEventSubject
      .map { BookmarkViewModel.Action.didTapDropdownCVS($0) }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 서치바 텍스트 반응
    header.searchBar.textField.rx.controlEvent(.editingDidEndOnExit)
      .withUnretained(self)
      .map { $0.0.header.searchBar.textField.text }
      .filterNil()
      .map { BookmarkViewModel.Action.didChangeSearchBarText($0) }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 테스트 로직
    header.infoTouchView.rx.tapGesture()
      .skip(1)
      .bind { _ in
        let popup = BookmarkPopup()
        popup.modalPresentationStyle = .overFullScreen
        self.present(popup, animated: false)
      }
      .disposed(by: disposeBag)

    // 정렬조건 변경
    sortDropdownView.buttonEventSubject
      .map { BookmarkViewModel.Action.didTapDropdownSort($0) }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // 이벤트 감지
    header.pageControl.didChangeEvent
      .skip(1)
      .distinctUntilChanged()
      .map { BookmarkViewModel.Action.didChangeEvent($0) }
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)

    // MARK: - State

    // 편의점 로고 드롭다운 애니메이션 동작
    viewModel.state
      .map { $0.isHiddenCVSDropdown }
      .distinctUntilChanged()
      .withUnretained(self)
      .bind { owner, isHidden in
        if isHidden {
          owner.cvsDropdownView.willDisappearDropdown()
        } else {
          owner.cvsDropdownView.willAppearDropdown()
        }
      }
      .disposed(by: disposeBag)

    // 필터 드롭다운 애니메이션 동작
    viewModel.state
      .map { $0.isHiddenSortDropdown }
      .distinctUntilChanged()
      .withUnretained(self)
      .bind { owner, isHidden in
        if isHidden {
          owner.sortDropdownView.willDisappearDropdown()
        } else {
          owner.sortDropdownView.willAppearDropdown()
        }
      }
      .disposed(by: disposeBag)

    // 현재 편의점 타입 변경 반응
    viewModel.state
      .map { $0.currentCVS }
      .withUnretained(self)
      .bind { owner, cvs in
        owner.header.cvsButton.setImage(cvs.image, for: .normal)
        owner.header.topCurveView.backgroundColor = cvs.bgColor
        owner.header.pageControl.focusedView.backgroundColor = cvs.bgColor
        owner.view.backgroundColor = cvs.bgColor
      }
      .disposed(by: disposeBag)

    // 현재 상품 목록
    viewModel.state
      .map { $0.currentProducts }
      .distinctUntilChanged()
      .withUnretained(self)
      .bind { $0.0.collectionView.reloadData() }
      .disposed(by: disposeBag)
  }
}

// MARK: - CollectionView Setup

extension BookmarkViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
    cell.updateCell(storage.products[indexPath.row])

    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return storage.products.count
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

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return .init(top: 24, left: 0, bottom: 16, right: 0)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    return .init(width: view.frame.width, height: 280)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return .init(width: view.frame.width, height: 125)
  }

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    sortDropdownView.willDisappearDropdown()
    cvsDropdownView.willDisappearDropdown()
  }
}
