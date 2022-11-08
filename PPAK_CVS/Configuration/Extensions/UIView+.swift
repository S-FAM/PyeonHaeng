import UIKit

extension UIView {
  func willAppearDropdown() {
    self.isHidden = false
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
      self.layer.opacity = 1
    }
  }

  func willDisappearDropdown() {
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
      self.layer.opacity = 0
    } completion: { _ in
      self.isHidden = true
    }
  }
}
