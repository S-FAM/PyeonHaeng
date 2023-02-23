import UIKit

extension UIView {
  func showDropdown() {
    self.isHidden = false
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
      self.layer.opacity = 1
    }
  }

  func hideDropdown() {
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
      self.layer.opacity = 0
    } completion: { _ in
      self.isHidden = true
    }
  }
}
