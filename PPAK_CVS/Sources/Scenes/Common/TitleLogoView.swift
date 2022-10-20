//
//  TitleLogoView.swift
//  PPAK_CVS
//
//  Created by hyeonseok on 2022/10/03.
//

import UIKit

class TitleLogoView: UIView {
  
  var titleLabel =  UILabel()
  var cvsType: CVSType
  
  init(cvsType: CVSType) {
    self.cvsType = cvsType
    super.init(frame: .zero)
    setTitle()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setTitle() {
    addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    titleLabel.text = cvsType.title
    titleLabel.textColor = cvsType.fontColor
    titleLabel.backgroundColor = cvsType.bgColor
  }
  
}
