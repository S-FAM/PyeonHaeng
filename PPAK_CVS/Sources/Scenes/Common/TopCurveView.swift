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
    path.move(to: CGPoint(x: 0, y: bounds.maxY))
    path.addCurve(
      to: CGPoint(x: 75, y: bounds.maxY - 75),
      controlPoint1: CGPoint(x: 0, y: bounds.maxY - 75),
      controlPoint2: CGPoint(x: 75, y: bounds.maxY - 75)
    )
    path.addLine(to: CGPoint(x: bounds.maxX - 75, y: bounds.maxY - 75))
    path.addCurve(
      to: CGPoint(x: bounds.maxX, y: bounds.maxY - 150),
      controlPoint1: CGPoint(x: bounds.maxX, y: bounds.maxY - 75),
      controlPoint2: CGPoint(x: bounds.maxX, y: bounds.maxY - 150)
    )
    path.addLine(to: CGPoint(x: bounds.maxX, y: 0))
    path.addLine(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: 0, y: bounds.maxY))

    let maskLayer = CAShapeLayer()
    maskLayer.frame = self.bounds
    maskLayer.path = path.cgPath
    self.layer.mask = maskLayer
  }
}
