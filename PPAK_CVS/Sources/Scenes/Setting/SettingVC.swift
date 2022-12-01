import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class SettingViewController: BaseViewController {

  // MARK: - Properties
  private lazy var headerBar: UIView = {
    let view = UIView()
    return view
  }()

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.alwaysBounceVertical = false
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
    tableView.backgroundColor = .systemTeal
    return tableView
  }()

  // MARK: - SetLayout
  override func setupStyles() {
    super.setupStyles()
    view.backgroundColor = .systemYellow
    headerBar.backgroundColor = .systemRed
  }

  override func setupLayouts() {
    super.setupLayouts()

    [headerBar, tableView].forEach {
      view.addSubview($0)
    }
  }

  override func setupConstraints() {
    super.setupConstraints()

    headerBar.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(50)
    }

    tableView.snp.makeConstraints {
      $0.top.equalTo(headerBar.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
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
    cell.setUI()

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
}
