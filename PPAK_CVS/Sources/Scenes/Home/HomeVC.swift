//
//  HomeViewController.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/09/12.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture
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

  private lazy var cvsDropdownView = CVSDropdownView()
  private lazy var filterDropdownView = FilterDropdownView()
  var header: HomeCollectionHeaderView!

  let viewModel = HomeViewModel()

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

  func setupDropdown() {
    [cvsDropdownView, filterDropdownView]
      .forEach {
        view.addSubview($0)
        $0.isHidden = true
      }

    cvsDropdownView.snp.makeConstraints { make in
      make.top.equalTo(header.cvsButton.snp.bottom).offset(16)
      make.leading.equalToSuperview().inset(16)
      make.width.equalTo(64)
      make.height.equalTo(376)
    }

    filterDropdownView.snp.makeConstraints { make in
      make.top.equalTo(header.filterButton.snp.bottom).offset(12)
      make.trailing.equalToSuperview().inset(16)
      make.width.equalTo(130)
      make.height.equalTo(100)
    }
  }

  // MARK: - Event

  private func bindHeader() {

    // -----------------------------------
    // ---------------INPUT---------------
    // -----------------------------------

    // 콜렉션뷰 헤더 최초 생성
    viewModel.input.ignoreReusableView.accept(true)

    // 현재 편의점 로고 버튼 클릭
    header.cvsButton.rx.tap
      .bind(to: viewModel.input.currentCVSButtonTapped)
      .disposed(by: disposeBag)

    // 필터 버튼 클릭
    header.filterButton.rx.tap
      .bind(to: viewModel.input.filterButtonTapped)
      .disposed(by: disposeBag)

    // 편의점 드롭다운 리스트 버튼 클릭
    cvsDropdownView.buttonEventSubject
      .bind(to: viewModel.input.dropdownCVSButtonTapped)
      .disposed(by: disposeBag)

    // 필터 드롭다운 리스트 버튼 클릭
    filterDropdownView.buttonEventSubject
      .bind(to: viewModel.input.dropdownFilterButtonTapped)
      .disposed(by: disposeBag)

    // 페이지 컨트롤 인덱스 감지
    header.pageControl.pageIndexSubject
      .bind(to: viewModel.input.pageControlIndexEvent)
      .disposed(by: disposeBag)

    // 빈공간 터치 감지
    view.rx.tapGesture()
      .map { _ in Void() }
      .bind(to: viewModel.input.touchBackgroundEvent)
      .disposed(by: disposeBag)

    // -----------------------------------
    // ---------------OUTPUT--------------
    // -----------------------------------

    // 편의점 로고 드롭다운 애니메이션 동작
    viewModel.output.cvsDropdownState
      .bind(onNext: { [weak self] state in
        guard let self = self else { return }
        if state {
          CVSDropdownView.showDropdown(self.cvsDropdownView)
        } else {
          CVSDropdownView.hideDropdown(self.cvsDropdownView)
        }
      })
      .disposed(by: disposeBag)

    // 필터 드롭다운 애니메이션 동작
    viewModel.output.filterDropdownState
      .bind(onNext: { [weak self] state in
        guard let self = self else { return }
        if state {
          FilterDropdownView.showDropdown(self.filterDropdownView)
        } else {
          FilterDropdownView.hideDropdown(self.filterDropdownView)
        }
      })
      .disposed(by: disposeBag)

    // 현재 선택된 편의점 로고 이미지 변경
    viewModel.output.cvsButtonImage
      .bind(onNext: { [weak self] imageName in
        guard let self = self else { return }
        self.header.cvsButton.setImage(UIImage(named: imageName), for: .normal)
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

    if viewModel.input.ignoreReusableView.value == false {
      self.header = header
      bindHeader()
      setupDropdown()
    }

    return header
  }
}
