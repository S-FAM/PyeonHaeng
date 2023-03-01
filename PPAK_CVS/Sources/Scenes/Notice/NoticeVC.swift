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

  private var remoteConfig: RemoteConfig?

  private let headerBar = UIView().then {
    $0.backgroundColor = .white
  }

  private let backButton = UIButton().then {
    $0.setImage(UIImage(named: "icon_left"), for: .normal)
    $0.tintColor = .black
  }

  private let titleLabel = UILabel().then {
    $0.text = Strings.Notice.title
    $0.font = Font.titleLabel
  }

  private let separateView = UIView().then {
    $0.backgroundColor = Color.separate
  }

  private let textView = UITextView().then {
    $0.font = Font.textView
    $0.isEditable = false
  }

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setRemoteConfig()
    self.getNotice()
  }

  // MARK: - Setup

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
      make.height.equalTo(Height.headerBar)
    }

    self.backButton.snp.makeConstraints { make in
      make.width.height.equalTo(Width.button)
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(Inset.common)
    }

    self.titleLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }

    self.separateView.snp.makeConstraints { make in
      make.top.equalTo(self.headerBar.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(Height.separate)
    }

    self.textView.snp.makeConstraints { make in
      make.top.equalTo(self.separateView.snp.bottom).offset(Inset.common)
      make.leading.trailing.bottom.equalToSuperview().inset(Inset.common)
    }
  }

  func bind(reactor: NoticeViewReactor) {
    // 뒤로 가기 버튼 클릭
    self.backButton.rx.tap
      .map { NoticeViewReactor.Action.back }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  /// Remote Config를 설정하는 함수입니다.
  private func setRemoteConfig() {
    self.remoteConfig = RemoteConfig.remoteConfig()
    let settings = RemoteConfigSettings()
    settings.minimumFetchInterval = 0
    self.remoteConfig?.configSettings = settings
    self.remoteConfig?.setDefaults(fromPlist: Strings.Notice.plistName)
  }

  /// Firebase Remote Config로 공지사항을 가져옵니다.
  private func getNotice() {
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
      let noticeMessage = (remoteConfig[Strings.Notice.remoteConfigKey].stringValue ?? "")
        .replacingOccurrences(of: "\\n", with: "\n")
      self?.textView.text = noticeMessage
    }
  }
}

// MARK: - Constant Collection

extension NoticeViewController {

  private enum Font {
    static let titleLabel = UIFont.appFont(family: .bold, size: 18)
    static let textView = UIFont.appFont(family: .regular, size: 14)
  }

  private enum Color {
    static let separate = UIColor.init(hex: "#DDDDDD")
  }

  private enum Width {
    static let button = 44.0
  }

  private enum Height {
    static let headerBar = 60
    static let separate = 0.5
  }

  private enum Inset {
    static let common = 16.0
  }
}
