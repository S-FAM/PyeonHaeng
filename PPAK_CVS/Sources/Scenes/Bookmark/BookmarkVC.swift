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

    // 테스트 로직
    header.infoButton.rx.tap
      .bind {
        let popup = BookmarkPopup()
        popup.modalPresentationStyle = .overFullScreen
        self.present(popup, animated: false)
      }
      .disposed(by: disposeBag)

//    // 필터 드롭다운 리스트 버튼 클릭
//    filterDropdownView.buttonEventSubject
//      .map { BookmarkViewModel.Action.filterButtonTappedInDropdown($0) }
//      .bind(to: viewModel.action)
//      .disposed(by: disposeBag)
//
//    // 페이지 컨트롤 인덱스 감지
//    header.pageControl.pageIndexSubject
//      .skip(1)
//      .distinctUntilChanged()
//      .map { BookmarkViewModel.Action.pageControlIndexEvent($0) }
//      .bind(to: viewModel.action)
//      .disposed(by: disposeBag)

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
          sortDropdownView.willAppearDropdown()
        } else {
          sortDropdownView.willDisappearDropdown()
        }
      })
      .disposed(by: disposeBag)

    // 현재 편의점 타입 변경 반응
    viewModel.state
      .compactMap { $0.currentCVSType }
      .bind(onNext: { [weak self] in
        self?.header.cvsButton.setImage($0.image, for: .normal)
        self?.header.topCurveView.backgroundColor = $0.bgColor
        self?.header.pageControl.focusedView.backgroundColor = $0.bgColor
      })
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
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct BookmarkVCPreView: PreviewProvider {
  static var previews: some View {
    BookmarkViewController().toPreview()
  }
}
#endif
