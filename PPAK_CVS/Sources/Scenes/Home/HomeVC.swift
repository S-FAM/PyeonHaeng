//
//  HomeViewController.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/09/12.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class HomeViewController: BaseViewController {

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

  let viewModel = HomeViewModel()
  var header: HomeCollectionHeaderView!

  // MARK: - Setup

  override func setupLayouts() {
    super.setupLayouts()
    view.addSubview(collectionView)
  }

  override func setupStyles() {
    navigationController?.isNavigationBarHidden = true
    view.backgroundColor = .white
  }

  override func setupConstraints() {
    collectionView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }

  // MARK: - Event

  private func bindHeader() {
    // -----------------------------------
    // ---------------INPUT---------------
    // -----------------------------------

    // 편의점 로고 버튼 클릭
    header.cvsButton.rx.tap
      .bind(to: viewModel.input.cvsButtonTapped)
      .disposed(by: disposeBag)

    // 필터 버튼 클릭
    header.filterButton.rx.tap
      .bind(to: viewModel.input.filterButtonTapped)
      .disposed(by: disposeBag)

    // -----------------------------------
    // ---------------OUTPUT--------------
    // -----------------------------------

    // 편의점 로고 드롭다운 애니메이션 동작
    viewModel.output.cvsDropdownState
      .bind(onNext: { [weak self] state in
        guard let self = self else { return }
        if state {
          CVSDropdownView.showDropdown(self.header.cvsDropdownView)
        } else {
          CVSDropdownView.hideDropdown(self.header.cvsDropdownView)
        }
      })
      .disposed(by: disposeBag)

    // 필터 드롭다운 애니메이션 동작
    viewModel.output.filterDropdownState
      .bind(onNext: { [weak self] state in
        guard let self = self else { return }
        if state {
          FilterDropdownView.showDropdown(self.header.filterDropdownView)
        } else {
          FilterDropdownView.hideDropdown(self.header.filterDropdownView)
        }
      })
      .disposed(by: disposeBag)
  }
}

// MARK: - CollectionView Setup

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
      withReuseIdentifier: HomeCollectionHeaderView.id,
      for: indexPath
    ) as? HomeCollectionHeaderView else { return UICollectionReusableView() }
    header.pageControl.delegate = self
    self.header = header
    bindHeader()

    // TODO: Header에 대한 Event처리는 여기서 처리할 것인지?

    return header
  }
}

// MARK: - PageControl Setup

extension HomeViewController: PageControlDelegate {
  func didChangedSelectedIndex(index: Int) {}
}
