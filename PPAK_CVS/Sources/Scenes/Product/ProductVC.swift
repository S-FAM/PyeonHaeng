//
//  ProductViewController.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/10/09.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class ProductViewController: BaseViewController, View {

  private var dataStore: ProductDataStore?

  private let navigationHeaderBarView = UIView().then {
    $0.backgroundColor = .white
  }

  private let featureStackView = UIStackView().then {
    $0.spacing = 20
  }

  private let backButton = UIButton().then {
    $0.setImage(UIImage(named: "ic_back"), for: .normal)
  }

  private let bookmarkButton = UIButton().then {
    $0.setImage(UIImage(named: "ic_heart_gray"), for: .normal)
    $0.setImage(UIImage(named: "ic_heart_red"), for: .selected)
  }

  private let shareButton = UIButton().then {
    $0.setImage(UIImage(named: "ic_share"), for: .normal)
  }

  private let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  ).then {
    $0.bounces = false
    $0.register(GoodsCell.self, forCellWithReuseIdentifier: GoodsCell.id)
    $0.register(
      ProductCollectionHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: ProductCollectionHeaderView.id
    )
    $0.backgroundColor = .systemPurple
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    collectionView.delegate = self
  }

  override func setupLayouts() {
    super.setupLayouts()
    [navigationHeaderBarView, collectionView].forEach {
      view.addSubview($0)
    }

    [backButton, featureStackView].forEach {
      navigationHeaderBarView.addSubview($0)
    }

    [bookmarkButton, shareButton].forEach {
      featureStackView.addArrangedSubview($0)
    }
  }

  override func setupConstraints() {
    super.setupConstraints()

    navigationHeaderBarView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(60)
    }

    backButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(16)
      make.size.equalTo(44)
    }

    featureStackView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(16)
    }

    [bookmarkButton, shareButton].forEach {
      $0.snp.makeConstraints { make in
        make.size.equalTo(44)
      }
    }

    collectionView.snp.makeConstraints { make in
      make.top.equalTo(navigationHeaderBarView.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }

  override func setupStyles() {
    super.setupStyles()
    view.backgroundColor = .white
  }

  func bind(reactor: ProductViewReactor) {

    // --- Action ---

    // 뒤로 가기 버튼 클릭
    self.backButton.rx.tap
      .map { ProductViewReactor.Action.back }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // 북마크 버튼 클릭
    self.bookmarkButton.rx.tap
      .map { ProductViewReactor.Action.bookmark(!self.bookmarkButton.isSelected) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // 공유 버튼 클릭
    self.shareButton.rx.tap
      .compactMap { [weak self] in self?.dataStore?.shareImage }
      .map { Reactor.Action.share($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // --- State ---

    reactor.state
      .map { $0.model.store.bgColor }
      .subscribe(with: self) { owner, backgroundColor in
        owner.collectionView.backgroundColor = backgroundColor
      }
      .disposed(by: disposeBag)

    // 이미지 공유하기
    reactor.state
      .map { $0.shareImage }
      .distinctUntilChanged()
      .compactMap { $0 }
      .subscribe(onNext: { [weak self] image in
        self?.presentShareSheet(items: [image])
      })
      .disposed(by: disposeBag)

    // 북마크 버튼 상태 적용하기
    reactor.state
      .map { $0.isBookmark }
      .bind(to: self.bookmarkButton.rx.isSelected)
      .disposed(by: disposeBag)
  }

  /// 공유버튼을 눌렀을 때 실행되는 메서드입니다.
  private func presentShareSheet(items: [Any]) {
    let shareSheetVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
    self.present(shareSheetVC, animated: true)
  }
}

extension ProductViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 0
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: GoodsCell.id,
      for: indexPath
    ) as? GoodsCell else {
      fatalError("GoodsCell을 생성할 수 없습니다.")
    }

    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    guard case UICollectionView.elementKindSectionHeader = kind,
          let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: ProductCollectionHeaderView.id,
            for: indexPath
          ) as? ProductCollectionHeaderView
    else {
      fatalError()
    }

    guard let reactor else { return headerView }

    headerView.configureUI(with: reactor.currentState.model)
    dataStore = headerView

    return headerView
  }
}

extension ProductViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: self.view.bounds.width, height: 125)
  }
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
    return CGSize(width: self.view.bounds.width, height: 404)
  }
}
