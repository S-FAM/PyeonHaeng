import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa
import RxGesture
import MessageUI

final class SettingViewController: BaseViewController, Viewable {

  // MARK: - Properties
  private lazy var headerBar = UIView().then {
    $0.backgroundColor = .white
  }

  private lazy var titleLabel = UILabel().then {
    $0.text = "설정"
    $0.font = .systemFont(ofSize: 18, weight: .bold)
  }

  private lazy var backButton = UIButton().then {
    $0.setImage(UIImage(named: "icon_left"), for: .normal)
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

    return SettingCellType.allCases.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: SettingTableViewCell.identifier
    ) as? SettingTableViewCell else { return UITableViewCell() }
    let settingValue = SettingCellType(rawValue: indexPath.row)
    cell.titleLabel.text = settingValue?.description
    cell.iconImage.image = settingValue?.image
    cell.setDetail(indexPath.row)
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    switch indexPath.row {
    case 0:
      // 푸시설정
      moveToSystemSetting()
    case 1:
      // 공지사항
      print("click: \(indexPath.row)")
    case 2:
      // 리뷰남기기
      print("click: \(indexPath.row)")
    case 3:
      // 문의하기
      sendMail()
    case 4:
      // 개발자 응원학
      print("click: \(indexPath.row)")
    case 5:
      // 버전정보
      print("click: \(indexPath.row)")
    default:
      break
    }
  }
}

// MARK: Send Mail
extension SettingViewController: MFMailComposeViewControllerDelegate {

  /// 메일보내기 기능
  private func sendMail() {
    if MFMailComposeViewController.canSendMail() {
      let mailComposeVC = MFMailComposeViewController()
      mailComposeVC.mailComposeDelegate = self
      mailComposeVC.setToRecipients(["bang.hyeonseok.dev@gmail.com"])
      mailComposeVC.setSubject("<편행> 문의하기")
      mailComposeVC.setMessageBody(bodyString(), isHTML: false)
      present(mailComposeVC, animated: true)
    } else {
      failAlertVC()
    }
  }

  /// 전송실패 메세지 얼럿
  private func failAlertVC() {
    let title = Message.sendMailFail
    let message = Message.retry
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let close = UIAlertAction(title: Message.cancel, style: .cancel)
    let move = UIAlertAction(title: Message.moveAppStore, style: .default) { [weak self] _ in
      self?.moveToAppStore()
    }

    [move, close].forEach { alert.addAction($0) }
    present(alert, animated: true)
  }

  // TODO: 앱스토어 링크 수정필요
  /// 앱스토어로 이동시키는 함수
  private func moveToAppStore() {
    if let url = URL(string: Configs.appStoreURL),
        UIApplication.shared.canOpenURL(url) {
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      } else {
        UIApplication.shared.openURL(url)
      }
    }
  }

  /// mail default contents
  private func bodyString() -> String {
    return """
           이곳에 내용을 작성해주세요.

           -------------------

           Device Model : \(getDeviceIdentifier())
           Device OS    : \(UIDevice.current.systemVersion)
           App Version  : \(getCurrentVersion())

           -------------------
           """
  }

  /// 앱 버전을 가져오는 함수
  private func getCurrentVersion() -> String {
    guard let dictionary = Bundle.main.infoDictionary,
          let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }

    return version
  }

  /// 기종을 가져오는 함수
  private func getDeviceIdentifier() -> String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    return identifier
  }

  private func getModel() -> String {
      var systemInfo = utsname()
      uname(&systemInfo)
      let machineMirror = Mirror(reflecting: systemInfo.machine)
      let model = machineMirror.children.reduce("") { identifier, element in
          guard let value = element.value as? Int8, value != 0 else { return identifier }
          return identifier + String(UnicodeScalar(UInt8(value)))
      }
      return model
  }

  /// after sending mail
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    dismiss(animated: true)
  }

  /// 시스템페이지로 이동처리
  func moveToSystemSetting() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }

    if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
    }
  }
}
