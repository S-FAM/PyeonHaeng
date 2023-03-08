//
//  CVSType.swift
//  PPAK_CVS
//
//  Created by hyeonseok on 2022/10/03.
//

import UIKit

/// 탭바 메뉴 타입
/// - Variables:
///     - title: 브랜드 명
///     - image: 로고이미지 이름
///     - bgColor: 태그의 배경색상
///     - fontColor: 태그의 폰트색상
enum CVSType: String, Codable {

  case cu = "CU"
  case gs = "GS25"
  case sevenEleven = "7-ELEVEn"
  case miniStop = "MINISTOP"
  case eMart = "emart24"
  case all

  var image: UIImage? {
    switch self {
    case .cu: return UIImage(named: "logo_cu")
    case .gs: return UIImage(named: "logo_gs25")
    case .sevenEleven: return UIImage(named: "logo_7eleven")
    case .miniStop: return UIImage(named: "logo_ministop")
    case .eMart: return UIImage(named: "logo_emart24")
    case .all: return UIImage(named: "ic_convenienceStore")
    }
  }

  var bgColor: UIColor {
    switch self {
    case .cu: return UIColor(hex: "#652D8E")
    case .gs: return UIColor(hex: "#62504E")
    case .sevenEleven: return UIColor(hex: "#008061")
    case .miniStop: return UIColor(hex: "#17469E")
    case .eMart: return UIColor(hex: "#FFB71D")
    case .all: return UIColor(hex: "#030026")
    }
  }

  var fontColor: UIColor {
    switch self {
    case .cu: return UIColor(hex: "#AACE38")
    case .gs: return UIColor(hex: "#1EC2DE")
    case .sevenEleven: return UIColor(hex: "#FFFFFF")
    case .miniStop: return UIColor(hex: "#F6F6F6")
    case .eMart: return UIColor(hex: "#62656A")
    case .all: return UIColor.white
    }
  }

  var badge: UIImage? {
    switch self {
    case .cu: return UIImage(named: "badge_cu")
    case .gs: return UIImage(named: "badge_gs25")
    case .sevenEleven: return UIImage(named: "badge_7eleven")
    case .miniStop: return UIImage(named: "badge_cu")
    case .eMart: return UIImage(named: "badge_emart24")
    case .all: return UIImage(named: "badge_cu")
    }
  }
}
