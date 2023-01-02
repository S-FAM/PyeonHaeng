//
//  BookmarkPopup.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2023/01/02.
//

import UIKit

import SnapKit
import Then

final class BookmarkPopup: BaseViewController {

  // MARK: - Properties

  private let containerView = UIView().then {
    $0.backgroundColor = .black.withAlphaComponent(0.9)
    $0.layer.cornerRadius = 20
  }

  private let infoLabel = UILabel().then {
    $0.text = "찜한 제품이 행사하는 경우, 매달 초(1~7일 사이)에 알림이 전송됩니다."
    $0.textColor = .white
    $0.numberOfLines = 2
  }

  // MARK: - LifeCycle

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      self.dismiss(animated: false)
    }
  }

  // MARK: - Setup

  override func setupStyles() {
    view.backgroundColor = .white.withAlphaComponent(0.4)
  }

  override func setupLayouts() {
    containerView.addSubview(infoLabel)
    view.addSubview(containerView)
  }

  override func setupConstraints() {
    containerView.snp.makeConstraints { make in
      make.width.equalTo(240)
      make.height.equalTo(100)
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().inset(131)
    }

    infoLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(17)
      make.centerY.equalToSuperview()
    }
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct AsdfPreView: PreviewProvider {
  static var previews: some View {
    BookmarkPopup().toPreview()
  }
}
#endif
