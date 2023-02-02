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

  // test data (will delete)
  private var previousHistory: [ProductModel] = []

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
  }

  private let shareButton = UIButton().then {
    $0.setImage(UIImage(named: "ic_share"), for: .normal)
  }

  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: .init()
  ).then {
    $0.collectionViewLayout = UICollectionViewFlowLayout().then { layout in
      layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 404)
      layout.itemSize = CGSize(width: self.view.bounds.width, height: 125)
      layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
    $0.bounces = false
    $0.register(GoodsCell.self, forCellWithReuseIdentifier: GoodsCell.id)
    $0.register(
      ProductCollectionHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: ProductCollectionHeaderView.id
    )
    $0.dataSource = self
    $0.backgroundColor = .systemPurple
  }

  private var collectionHeaderView: ProductCollectionHeaderView? {
    willSet {
      guard let newValue = newValue else { return }
      newValue.reactor = ProductHeaderViewReactor()
      bind(newValue)
      self.headerViewInitializeRelay.accept(newValue)
    }
  }

  private let headerViewInitializeRelay = PublishRelay<ProductCollectionHeaderView>()

  override func viewDidLoad() {
    super.viewDidLoad()
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

    let modelObservable = reactor.state.map { $0.model }
    let headerViewObservable = headerViewInitializeRelay.asObservable()

    Observable.combineLatest(modelObservable, headerViewObservable)
      .subscribe(onNext: { [weak self] model, headerView in
        headerView.configureUI(with: model)

        // --- test data(will delete) ---
        self?.previousHistory.append(
          ProductModel(
            imageLink: model.imageLink,
            name: "2022년 12월 행사 가격",
            price: model.price,
            store: model.store,
            saleType: model.saleType
          )
        )
        self?.previousHistory.append(
          ProductModel(
            imageLink: model.imageLink,
            name: "2022년 11월 행사 가격",
            price: model.price,
            store: model.store,
            saleType: model.saleType
          )
        )
        self?.previousHistory.append(
          ProductModel(
            imageLink: model.imageLink,
            name: "2022년 10월 행사 가격",
            price: model.price,
            store: model.store,
            saleType: model.saleType
          )
        )
        // -------------------

        self?.collectionView.reloadData()
        self?.collectionView.backgroundColor = model.store.bgColor
      })
      .disposed(by: disposeBag)
  }

  func bind(_ headerView: ProductCollectionHeaderView) {
    guard let headerViewModel = headerView.reactor else { return }

    headerViewModel.state
      .map { $0.shareImage }
      .distinctUntilChanged()
      .compactMap { $0 }
      .subscribe(onNext: { [weak self] image in
        self?.presentShareSheet(items: [image])
      })
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
    return self.previousHistory.count
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

    cell.updateCell(self.previousHistory[indexPath.row], isShowTitleLogoView: false)
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

    if self.collectionHeaderView == nil {
      self.collectionHeaderView = headerView
    }

    return headerView
  }
}
