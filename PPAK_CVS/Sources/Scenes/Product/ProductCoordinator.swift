//
//  ProductCoordinator.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/10/09.
//

import UIKit

import RxSwift
import RxCocoa

final class ProductCoordinator: BaseCoordinator {

  // MARK: - Properties

  private let model: ProductModel

  // MARK: - Initializations

  init(_ navigationController: UINavigationController, model: ProductModel) {
    self.model = model
    super.init(navigationController: navigationController)
  }

  private override init(navigationController: UINavigationController) {
    self.model = ProductModel(imageLink: "", name: "", price: 0, store: .all, saleType: .all)
    super.init(navigationController: navigationController)
  }

  // MARK: - Coordinator functions

  override func start() {
    let viewController = ProductViewController()
    let reactor = ProductViewReactor()
    viewController.coordinator = self
    viewController.reactor = reactor
    self.navigationController.pushViewController(viewController, animated: true)
    bind(reactor)
  }

  private func bind(_ reactor: ProductViewReactor) {
    Observable<ProductViewReactor.Action>.just(.updateProduct(self.model))
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // 홈 화면으로 이동하기
    reactor.state.map { $0.isPopProductVC }
      .bind { [weak self] isPop in
        if isPop {
          self?.navigationController.popViewController(animated: true)
        }
      }.disposed(by: disposeBag)
  }
}
