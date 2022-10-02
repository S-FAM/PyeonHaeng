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
    let cvsButtonTapped = PublishSubject<Void>()
    let filterButtonTapped = PublishSubject<Void>()
  }

  struct Output {
    let cvsDropdownState = BehaviorRelay<Bool>(value: false)
    let filterDropdownState = BehaviorRelay<Bool>(value: false)
  }

  let input = Input()
  let output = Output()
  let disposeBag = DisposeBag()

  init() {
    bind()
  }

  func bind() {

    // 편의점 로고 버튼 이벤트 -> 드롭다운 애니메이션
    input.cvsButtonTapped
      .map { [unowned self] in
        !self.output.cvsDropdownState.value
      }
      .bind(to: output.cvsDropdownState)
      .disposed(by: disposeBag)

    // 필터 버튼 이벤트 -> 드롭다운 애니메이션
    input.filterButtonTapped
      .map { [unowned self] in
        !self.output.filterDropdownState.value
      }
      .bind(to: output.filterDropdownState)
      .disposed(by: disposeBag)
  }
}
