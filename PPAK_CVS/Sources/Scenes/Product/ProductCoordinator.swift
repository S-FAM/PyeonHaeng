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
  private let disposeBag = DisposeBag()

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
    let viewModel = ProductViewModel()
    viewController.coordinator = self
    viewController.viewModel = viewModel
    self.navigationController.pushViewController(viewController, animated: true)
    bind(viewModel)
  }

  private func bind(_ viewModel: ProductViewModel) {
    Observable<ProductViewModel.Action>.just(.updateProduct(self.model))
      .bind(to: viewModel.action)
      .disposed(by: disposeBag)
  }
}
