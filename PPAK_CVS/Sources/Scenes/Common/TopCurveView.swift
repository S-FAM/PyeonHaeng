//
//  TopCurveView.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/09/16.
//

import UIKit

final class TopCurveView: UIView {

  private let heightRatio: CGFloat = 2.8  // height의 2.8분의 1 비율
  private let widthRatio: CGFloat = 0.2   // width의 0.2배 비율

  override func draw(_ rect: CGRect) {
    super.draw(rect)

    let middleBeforeWidth = bounds.maxX * widthRatio
    let middleBeforeHeight = bounds.maxY - bounds.maxY / heightRatio
    let middleAfterWidth = bounds.maxX - middleBeforeWidth
    let endHeight = middleBeforeHeight / 2

    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: bounds.maxY))

    // draw curve
    path.addCurve(
      to: CGPoint(x: middleBeforeWidth, y: middleBeforeHeight),
      controlPoint1: CGPoint(x: 0, y: middleBeforeHeight),
      controlPoint2: CGPoint(x: middleBeforeWidth, y: middleBeforeHeight)
    )

    // width의 4/5까지 선으로 그음
    path.addLine(to: CGPoint(x: middleAfterWidth, y: middleBeforeHeight))

    path.addCurve(
      to: CGPoint(x: bounds.maxX, y: endHeight),
      controlPoint1: CGPoint(x: bounds.maxX, y: middleBeforeHeight),
      controlPoint2: CGPoint(x: bounds.maxX, y: endHeight)
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
