//
//  TitleLogoView.swift
//  PPAK_CVS
//
//  Created by hyeonseok on 2022/10/03.
//

import UIKit

import Then
import SnapKit

final class TitleLogoView: UIView {

  private lazy var titleButton = UIButton().then {
    var config = UIButton.Configuration.filled()
    var container = AttributeContainer()
    container.foregroundColor = cvsType.fontColor
    // TODO: 폰트 추가하기
    config.attributedTitle = AttributedString(
      cvsType.rawValue,
      attributes: container
    )
    config.cornerStyle = .capsule
    config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
    config.baseBackgroundColor = cvsType.bgColor

    $0.configuration = config
    $0.isUserInteractionEnabled = false
  }

  private let cvsType: CVSType

  init(cvsType: CVSType) {
    self.cvsType = cvsType
    super.init(frame: .zero)
    setTitle()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setTitle() {
    addSubview(titleButton)

    titleButton.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
