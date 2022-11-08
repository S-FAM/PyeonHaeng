//
//  ProductViewController.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/10/09.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class ProductViewController: BaseViewController {

  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: .init()
  ).then {
    $0.collectionViewLayout = UICollectionViewFlowLayout().then { layout in
      layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 460)
      layout.itemSize = CGSize(width: self.view.bounds.width, height: 125)
      layout.sectionInset = UIEdgeInsets(top: 24, left: 0, bottom: 16, right: 0)
    }
    $0.contentInsetAdjustmentBehavior = .never
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
      newValue.viewModel = ProductHeaderViewViewModel()
      bind(newValue)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func setupLayouts() {
    super.setupLayouts()

    // navigation bar
    navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "heart"),
      style: .plain,
      target: self,
      action: nil
    )

    navigationItem.titleView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 50)).then {
      $0.backgroundColor = .systemGray
    }

    // add views
    view.addSubview(collectionView)
  }

  override func setupConstraints() {
    super.setupConstraints()

    collectionView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }

  func bind(_ headerView: ProductCollectionHeaderView) {
    guard let headerViewModel = headerView.viewModel else { return }

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
    return 10
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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

    if self.collectionHeaderView == nil {
      self.collectionHeaderView = headerView
    }

    return headerView
  }
}
