//
//  OnboardingViewModel.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2022/10/05.
//

import UIKit

import RxSwift
import RxCocoa

enum SwipeDirection {
  case left
  case right
}

final class OnboardingViewModel {

  struct Input {
    let skipButtonEvent = PublishSubject<Void>()
    let nextButtonEvent = PublishSubject<Void>()
    let swipeGestureDetector = PublishSubject<SwipeDirection>()
  }

  struct Output {
    let currentPage = BehaviorRelay<Int>(value: 0)
    let navigateToHomeVC = PublishSubject<Void>()
  }

  let input = Input()
  let output = Output()
  private let disposeBag = DisposeBag()

  var currentPage: Int {
    return output.currentPage.value
  }

  init() {
    self.bind()
  }

  private func bind() {

    // --- INPUT ---

    // 건너뛰기 버튼 이벤트 -> 홈 화면으로 이동
    self.input.skipButtonEvent
      .bind(to: self.output.navigateToHomeVC)
      .disposed(by: self.disposeBag)

    // 다음 버튼 이벤트(1) -> 마지막 페이지일 때 홈 화면으로 이동
    self.input.nextButtonEvent
      .filter { [weak self] in
        self?.currentPage == 2
      }
      .bind(to: self.output.navigateToHomeVC)
      .disposed(by: disposeBag)

    // 다음 버튼 이벤트(2) -> 페이지 1씩 증가
    self.input.nextButtonEvent
      .filter { [unowned self] in
        self.currentPage < 2
      }
      .bind { [weak self] in
        guard let self = self else { return }
        let updatedPage = self.currentPage + 1
        self.output.currentPage.accept(updatedPage)
      }
      .disposed(by: disposeBag)

    // 스와이프 제스처
    self.input.swipeGestureDetector
      .bind { [weak self] direction in
        guard let self = self else { return }
        switch direction {
        case .left:
          if self.currentPage < 2 {
            let updatedPage = self.currentPage + 1
            self.output.currentPage.accept(updatedPage)
          }
        case .right:
          if self.currentPage > 0 {
            let updatedPage = self.currentPage - 1
            self.output.currentPage.accept(updatedPage)
          }
        }
      }
      .disposed(by: disposeBag)
  }
}
