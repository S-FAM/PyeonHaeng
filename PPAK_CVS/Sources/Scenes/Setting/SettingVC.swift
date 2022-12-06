import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

final class SettingViewController: BaseViewController {

  // MARK: - Properties
  private lazy var headerBar = UIView().then {
    $0.backgroundColor = .systemRed
  }

  private lazy var tableView = UITableView().then {
    $0.alwaysBounceVertical = false
    $0.dataSource = self
    $0.delegate = self
    $0.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
    $0.backgroundColor = .systemTeal
  }

  // MARK: - SetLayout
  override func setupStyles() {
    super.setupStyles()
    view.backgroundColor = .systemYellow
  }

  override func setupLayouts() {
    super.setupLayouts()
    [headerBar, tableView].forEach {
      view.addSubview($0)
    }
  }

  override func setupConstraints() {
    super.setupConstraints()

    headerBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(60)
    }

    tableView.snp.makeConstraints { make in
      make.top.equalTo(headerBar.snp.bottom).offset(10)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }
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
