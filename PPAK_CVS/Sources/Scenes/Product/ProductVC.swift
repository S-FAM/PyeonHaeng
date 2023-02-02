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
  
  var productModel = ProductModel.EMPTY
  var isBookmarkedProduct: Bool = false

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

  private var collectionHeaderView: ProductCollectionHeaderView! {
    willSet {
      guard let newValue = newValue else { return }
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
    
    // --- Action ---
    
    // 뒤로 가기 버튼 클릭
    self.backButton.rx.tap
      .map { ProductViewReactor.Action.back }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // 북마크 버튼 클릭
    self.bookmarkButton.rx.tap
      .map { ProductViewReactor.Action.bookmark(self.isBookmarkedProduct) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // 공유 버튼 클릭
    self.shareButton.rx.tap
      .map { ProductViewReactor.Action.share((self.collectionHeaderView.getShareImage())) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // --- State ---

    // 제품 정보 받아오기
    let modelObservable = reactor.state.map { $0.model }
    let headerViewObservable = headerViewInitializeRelay.asObservable()

    Observable.combineLatest(modelObservable, headerViewObservable)
      .subscribe(onNext: { [weak self] model, headerView in
        guard let self = self else { return }
        
        headerView.configureUI(with: model)
        
        self.productModel = model
        self.isBookmarkedProduct = ProductStorage.shared.contains(self.productModel)
        self.updateBookmarkState(isBookmark: self.isBookmarkedProduct)

        // --- test data(will delete) ---
        self.previousHistory.append(
          ProductModel(
            imageLink: model.imageLink,
            name: "2022년 12월 행사 가격",
            price: model.price,
            store: model.store,
            saleType: model.saleType
          )
        )
        self.previousHistory.append(
          ProductModel(
            imageLink: model.imageLink,
            name: "2022년 11월 행사 가격",
            price: model.price,
            store: model.store,
            saleType: model.saleType
          )
        )
        self.previousHistory.append(
          ProductModel(
            imageLink: model.imageLink,
            name: "2022년 10월 행사 가격",
            price: model.price,
            store: model.store,
            saleType: model.saleType
          )
        )
        // -------------------

        self.collectionView.reloadData()
        self.collectionView.backgroundColor = model.store.bgColor
      })
      .disposed(by: disposeBag)
    
    // 이미지 공유하기
    reactor.state
      .map { $0.shareImage }
      .compactMap { $0 }
      .subscribe(onNext: { [weak self] image in
        self?.presentShareSheet(items: [image])
      })
      .disposed(by: disposeBag)
    
    // 북마크 상태 저장하기
    reactor.state
      .map { $0.isBookmark }
      .bind { [weak self] isBookmark in
        self?.updateBookmarkState(isBookmark: isBookmark)
      }
      .disposed(by: disposeBag)
  }

  /// 공유버튼을 눌렀을 때 실행되는 메서드입니다.
  private func presentShareSheet(items: [Any]) {
    let shareSheetVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
    self.present(shareSheetVC, animated: true)
  }
  
  /// 북마크버튼을 눌렀을 때 실행되는 메서드입니다.
  private func updateBookmarkState(isBookmark: Bool) {
    if isBookmark {
      self.bookmarkButton.setImage(UIImage(named: "ic_heart_red"), for: .normal)
      ProductStorage.shared.add(self.productModel)
    } else {
      self.bookmarkButton.setImage(UIImage(named: "ic_heart_gray"), for: .normal)
      ProductStorage.shared.remove(self.productModel)
    }
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
