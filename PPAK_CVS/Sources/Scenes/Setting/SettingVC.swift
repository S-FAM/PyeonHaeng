import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

final class SettingViewController: BaseViewController, Viewable {

  // MARK: - Properties
  private lazy var headerBar = UIView().then {
    $0.backgroundColor = .white
  }

  private lazy var titleLabel = UILabel().then {
    $0.text = "설정"
    $0.font = .systemFont(ofSize: 17, weight: .regular)
  }

  private lazy var backButton = UIButton().then {
    $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    $0.tintColor = .black
    $0.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
  }

  private lazy var tableView = UITableView().then {
    $0.alwaysBounceVertical = false
    $0.dataSource = self
    $0.delegate = self
    $0.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
    $0.backgroundColor = .white
  }

  // MARK: - SetLayout

  override func setupStyles() {
    super.setupStyles()
    view.backgroundColor = .white
    setGesture()
  }

  override func setupLayouts() {
    super.setupLayouts()
    [headerBar, tableView].forEach {
      view.addSubview($0)
    }

    [backButton, titleLabel].forEach {
      headerBar.addSubview($0)
    }
  }

  override func setupConstraints() {
    super.setupConstraints()

    headerBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(60)
    }

    backButton.snp.makeConstraints { make in
      make.width.height.equalTo(44)
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(16)
    }

    titleLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }

    tableView.snp.makeConstraints { make in
      make.top.equalTo(headerBar.snp.bottom).offset(10)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }

  private func setGesture() {
    let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(backButtonAction))
    view.addGestureRecognizer(swipeGesture)
  }

  @objc func backButtonAction() {
    navigationController?.popViewController(animated: true)
  }

  func bind(viewModel: SettingViewModel) { }
}

// MARK: - TableView Delegate

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: SettingTableViewCell.identifier
    ) as? SettingTableViewCell else { return UITableViewCell() }

    cell.setUI(indexPath.row)
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
}
