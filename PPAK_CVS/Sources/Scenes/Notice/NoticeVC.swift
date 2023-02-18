//
//  NoticeVC.swift
//  PPAK_CVS
//
//  Created by 김민지 on 2023/02/18.
//

import UIKit

import FirebaseRemoteConfig
import ReactorKit
import RxCocoa
import SnapKit
import Then

final class NoticeViewController: BaseViewController, View {

  // MARK: - Properties

  var remoteConfig: RemoteConfig?

  private lazy var headerBar = UIView().then {
    $0.backgroundColor = .white
  }

  private lazy var backButton = UIButton().then {
    $0.setImage(UIImage(named: "icon_left"), for: .normal)
    $0.tintColor = .black
  }

  private lazy var titleLabel = UILabel().then {
    $0.text = "공지사항"
    $0.font = UIFont.appFont(family: .bold, size: 18)
  }

  private var separateView = UIView().then {
    $0.backgroundColor = UIColor.init(hex: "#DDDDDD")
  }

  private lazy var textView = UITextView().then {
    $0.font = UIFont.appFont(family: .regular, size: 14)
    $0.isEditable = false
  }

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.remoteConfig = RemoteConfig.remoteConfig()
    let settings = RemoteConfigSettings()
    settings.minimumFetchInterval = 0
    self.remoteConfig?.configSettings = settings
    self.remoteConfig?.setDefaults(fromPlist: "NoticeInfo")

    self.getNotice()
  }

  // MARK: - Setup

  override func setupStyles() {
    super.setupStyles()
    view.backgroundColor = .white
  }

  override func setupLayouts() {
    super.setupLayouts()
    [self.headerBar, self.separateView, self.textView].forEach {
      view.addSubview($0)
    }

    [self.backButton, self.titleLabel].forEach {
      headerBar.addSubview($0)
    }
  }

  override func setupConstraints() {
    super.setupConstraints()

    self.headerBar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(60)
    }

    self.backButton.snp.makeConstraints { make in
      make.width.height.equalTo(44)
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(16)
    }

    self.titleLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }

    self.separateView.snp.makeConstraints { make in
      make.top.equalTo(self.headerBar.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(0.5)
    }

    self.textView.snp.makeConstraints { make in
      make.top.equalTo(self.separateView.snp.bottom).offset(16)
      make.leading.trailing.bottom.equalToSuperview().inset(16)
    }
  }

  func bind(reactor: NoticeViewReactor) {
    // 뒤로 가기 버튼 클릭
    self.backButton.rx.tap
      .map { NoticeViewReactor.Action.back }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  /// Firebase Remote Config로 공지사항을 가져옵니다.
  func getNotice() {
    guard let remoteConfig = self.remoteConfig else {
      return
    }
    remoteConfig.fetch { [weak self] status, error in
      if status == .success {
        print("Config fetched!")
        remoteConfig.activate(completion: nil)
      } else {
        print("Config not fetched")
        print("Error: \(error?.localizedDescription ?? "No error available.")")
      }
      let noticeMessage = (remoteConfig["notice_contents"].stringValue ?? "")
        .replacingOccurrences(of: "\\n", with: "\n")
      self?.textView.text = noticeMessage
    }
  }
}
