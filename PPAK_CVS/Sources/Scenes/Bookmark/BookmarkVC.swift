import UIKit

import Lottie
import Then
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa
import RxGesture

final class BookmarkViewController: BaseViewController, View {

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

  private let animationContainerView = UIView().then {
    $0.backgroundColor = .clear
  }

  private let animationView = AnimationView(name: "noBookmark").then {
    $0.contentMode = .scaleAspectFill
    $0.loopMode = .loop
  }

  private let noBookmarkLabel = UILabel().then {
    $0.textColor = .lightGray
    $0.font = .appFont(family: .regular, size: 15)
    $0.text = "찜한 제품이 없습니다."
  }

  override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
  private let indicator = UIActivityIndicatorView()
  private let sortDropdownView = SortDropdownView()
  private let cvsDropdownView = CVSDropdownView()
  private var header: BookmarkCollectionHeaderView!

  // MARK: - Setup

  override func setupStyles() {
    super.setupStyles()
    view.backgroundColor = CVSType.all.bgColor
  }

  override func setupLayouts() {
    super.setupLayouts()
    view.addSubview(collectionView)
    view.addSubview(animationContainerView)
  }

  override func setupConstraints() {
    collectionView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide)
    }
  }

  private func setupDropdown() {
    view.addSubview(indicator)

    [
      sortDropdownView,
      cvsDropdownView
    ].forEach {
      view.addSubview($0)
      $0.isHidden = true
    }

    indicator.snp.makeConstraints { make in
      make.center.equalToSuperview()
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

    animationContainerView.addSubview(stack)

    stack.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }

    animationContainerView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalTo(collectionView)
      make.top.equalTo(header.snp.bottom)
    }

    animationView.snp.makeConstraints { make in
      make.width.equalTo(165)
      make.height.equalTo(107)
    }

    animationView.play()
  }

  // MARK: - Bind

  func bind(reactor: BookmarkViewReactor) {}

  private func bindHeader() {
    guard let reactor = reactor else { return }

    // MARK: - Action

    // 뒤로 가기 버튼 클릭
    header.backButton.rx.tap
      .map { BookmarkViewReactor.Action.didTapBackButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // 현재 편의점 로고 버튼 클릭
    header.cvsButton.rx.tap
      .map { BookmarkViewReactor.Action.didTapCVSButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // 필터 버튼 클릭
    header.filterButton.rx.tap
      .map { BookmarkViewReactor.Action.didTapSortButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // 편의점 드롭다운 리스트 버튼 클릭
    cvsDropdownView.buttonEventSubject
      .map { BookmarkViewReactor.Action.didTapDropdownCVS($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // 서치바 텍스트 반응
    header.searchBar.textField.rx.controlEvent(.editingDidEndOnExit)
      .withUnretained(self)
      .map { $0.0.header.searchBar.textField.text }
      .filterNil()
      .map { BookmarkViewReactor.Action.didChangeSearchBarText($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // 찜 정보 터치
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
      .map { BookmarkViewReactor.Action.didTapDropdownSort($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // 이벤트 감지
    header.pageControl.didChangeEvent
      .skip(1)
      .distinctUntilChanged()
      .map { BookmarkViewReactor.Action.didChangeEvent($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // 빈공간 터치 이벤트
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
    .map { _ in BookmarkViewReactor.Action.didTapBackground }
    .bind(to: reactor.action)
    .disposed(by: disposeBag)

    // MARK: - State

    // 편의점 로고 드롭다운 애니메이션 동작
    reactor.state
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
    reactor.state
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
    reactor.state
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
    reactor.state
      .map { $0.currentProducts }
      .distinctUntilChanged()
      .withUnretained(self)
      .bind { $0.0.collectionView.reloadData() }
      .disposed(by: disposeBag)

    // 로딩 중
    reactor.state
      .map { $0.isLoading }
      .distinctUntilChanged()
      .bind(to: indicator.rx.isAnimating)
      .disposed(by: disposeBag)

    // 서치바 텍스트
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

// MARK: - CollectionView Setup

extension BookmarkViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let products = reactor?.currentState.currentProducts else {
      return UICollectionViewCell()
    }

    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: GoodsCell.id,
      for: indexPath
    ) as? GoodsCell else {
      return UICollectionViewCell()
    }
    cell.updateCell(products[indexPath.row], isShowTitleLogoView: true)

    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    guard let products = reactor?.currentState.currentProducts else { return 0 }
    return products.count
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
      setupAnimationView()
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
