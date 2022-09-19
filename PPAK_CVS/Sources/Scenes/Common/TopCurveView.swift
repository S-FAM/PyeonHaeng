//
//  TopCurveView.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/09/16.
//

import UIKit

final class TopCurveView: UIView {
  override func draw(_ rect: CGRect) {
    super.draw(rect)

    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: self.bounds.maxY))
    path.addCurve(
      to: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY - 150),
      controlPoint1: CGPoint(x: 0, y: self.bounds.maxY - 150),
      controlPoint2: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY)
    )
    path.addLine(to: CGPoint(x: self.bounds.maxX, y: 0))
    path.addLine(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: 0, y: self.bounds.maxY))

    let maskLayer = CAShapeLayer()
    maskLayer.frame = self.bounds
    maskLayer.path = path.cgPath
    self.layer.mask = maskLayer
  }
}
