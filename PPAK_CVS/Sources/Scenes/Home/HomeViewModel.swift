//
//  HomeViewModel.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/09/27.
//

import RxSwift
import RxCocoa

final class HomeViewModel {
  struct Input {
    let ignoreReusableView = BehaviorRelay<Bool>(value: false)

    let currentCVSButtonTapped = PublishSubject<Void>()
    let filterButtonTapped = PublishSubject<Void>()
    let touchBackgroundEvent = PublishSubject<Void>()
    let pageControlIndexEvent = PublishSubject<Int>()
    let dropdownCVSButtonTapped = PublishSubject<CVSDropdownCase>()
    let dropdownFilterButtonTapped = PublishSubject<FilterDropdownCase>()
  }

  struct Output {
    let cvsDropdownState = BehaviorRelay<Bool>(value: false)
    let filterDropdownState = BehaviorRelay<Bool>(value: false)
    let cvsButtonImage = PublishSubject<String>()
  }

  let input = Input()
  let output = Output()
  let disposeBag = DisposeBag()

  init() {
    bind()
  }

  func bind() {

    // 현재 편의점 로고 버튼 이벤트 -> 드롭다운 토글
    input.currentCVSButtonTapped
      .map { [unowned self] in
        !self.output.cvsDropdownState.value
      }
      .bind(to: output.cvsDropdownState)
      .disposed(by: disposeBag)

    // 필터 버튼 이벤트 -> 드롭다운 토글
    input.filterButtonTapped
      .map { [unowned self] in
        !self.output.filterDropdownState.value
      }
      .bind(to: output.filterDropdownState)
      .disposed(by: disposeBag)

    // 드롭다운 편의점 로고 버튼 이벤트 -> 드롭다운 숨기기
    input.dropdownCVSButtonTapped
      .map { _ in false }
      .bind(to: output.cvsDropdownState)
      .disposed(by: disposeBag)

    // 드롭다운 필터 버튼 이벤트 -> 드롭다운 숨기기
    input.dropdownFilterButtonTapped
      .map { _ in false }
      .bind(to: output.filterDropdownState)
      .disposed(by: disposeBag)

    // 빈 공간 터치 -> 드롭다운 모두 숨기기
    input.touchBackgroundEvent
      .bind(onNext: { [unowned self] in
        self.output.cvsDropdownState.accept(false)
        self.output.filterDropdownState.accept(false)
      })
      .disposed(by: disposeBag)

    // 편의점 드롭다운 요소 클릭 -> 현재 편의점 버튼 이미지 변경
    input.dropdownCVSButtonTapped
      .map { $0.imageName }
      .bind(to: output.cvsButtonImage)
      .disposed(by: disposeBag)
  }
}
