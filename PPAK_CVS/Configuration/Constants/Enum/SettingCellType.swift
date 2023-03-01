//
//  SettingCellType.swift
//  PPAK_CVS
//
//  Created by hyeonseok on 2023/01/15.
//

import UIKit

enum SettingCellType: Int, CaseIterable, CustomStringConvertible {
  // TODO: - 개발자응원하기 수정후, versionInfo와 순서 수정
  case push
  case selectStore
  case notice
  case review
  case sendMail
  case versionInfo
  case supportDeveloper

  var image: UIImage? {
    switch self {
    case .push:
      return UIImage(named: "icon_alert")
    case .selectStore:
      return UIImage(named: "icon_selectStore")
    case .notice:
      return UIImage(named: "icon_noti")
    case .review:
      return UIImage(named: "icon_review")
    case .sendMail:
      return UIImage(named: "icon_mail")
    case .supportDeveloper:
      return UIImage(named: "info_cheer")
    case .versionInfo:
      return UIImage(named: "icon_version")
    }
  }

  var description: String {
    switch self {
    case .push:
      return "알림"
    case .selectStore:
      return "자주 가는 편의점"
    case .notice:
      return "공지사항"
    case .review:
      return "리뷰 남기기"
    case .sendMail:
      return "문의하기"
    case .supportDeveloper:
      return "개발자 응원하기"
    case .versionInfo:
      return "버전정보"
    }
  }
}
