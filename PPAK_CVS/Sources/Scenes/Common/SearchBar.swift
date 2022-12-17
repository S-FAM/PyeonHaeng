//
//  SearchBar.swift
//  PPAK_CVS
//
//  Created by 김응철 on 2022/09/18.
//

import UIKit

final class SearchBar: UIView {

  // MARK: - Properties

  var imageView: UIImageView!
  var textField: UITextField!

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupStyles()
    setupImageView()
    setupTextField()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - LifeCycle

  override func layoutSubviews() {
    super.layoutSubviews()

    imageView.frame = CGRect(x: 20, y: 0, width: 30, height: 30)
    imageView.center.y = self.bounds.midY

    textField.frame = CGRect(x: 65, y: 0, width: self.bounds.width - 80, height: self.bounds.height - 20)
    textField.center.y = self.bounds.midY
  }

  // MARK: - Setup

  private func setupStyles() {
    self.backgroundColor = .white
    self.layer.shadowOffset = CGSize(width: 0, height: 0)
    self.layer.cornerRadius = 10
    self.layer.shadowOpacity = 0.1
    self.layer.shadowColor = UIColor.black.cgColor
  }

  private func setupImageView() {
    let imageView = UIImageView(image: UIImage(named: "ic_magnifyingGlass"))
    self.imageView = imageView
    self.addSubview(imageView)
  }

  private func setupTextField() {
    let textField = UITextField()
    self.textField = textField
    self.addSubview(textField)
    textField.placeholder = "search"
  }
}
