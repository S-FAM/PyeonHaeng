//
//  BookmarkVC.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/10/08.
//

import UIKit

import Then
import SnapKit

final class BookmarkViewController: BaseViewController {

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
    $0.register(BookmarkCollectionHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: BookmarkCollectionHeaderView.id)
    $0.register(GoodsCell.self,
                forCellWithReuseIdentifier: GoodsCell.id)
  }

  private lazy var filterDropdownView = FilterDropdownView()
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
    view.addSubview(filterDropdownView)
    filterDropdownView.isHidden = true

    filterDropdownView.snp.makeConstraints { make in
      make.top.equalTo(header.filterButton.snp.bottom).offset(12)
      make.trailing.equalToSuperview().inset(16)
      make.width.equalTo(130)
      make.height.equalTo(100)
    }
  }

  // MARK: - Bind

  private func bindHeader() {

  }
}

// MARK: - CollectionView Setup

extension BookmarkViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: GoodsCell.id,
      for: indexPath
    ) as? GoodsCell else {
      return UICollectionViewCell()
    }
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

    self.header = header
    bindHeader()
    setupDropdown()

    return header
  }
}
