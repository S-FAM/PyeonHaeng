//
//  CvsType.swift
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
enum CVSType: String, Codable, CaseIterable {

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
    case .all: return UIImage(named: "logo_all")
    }
  }

  var bgColor: UIColor {
    switch self {
    case .cu: return UIColor(hex: "#751485")
    case .gs: return UIColor(hex: "#63514D")
    case .sevenEleven: return UIColor(hex: "#FF8329")
    case .miniStop: return UIColor(hex: "#003893")
    case .eMart: return UIColor(hex: "#56555B")
    case .all: return UIColor(hex: "#030026")
    }
  }

  var fontColor: UIColor {
    switch self {
    case .cu: return UIColor(hex: "#9DC92A")
    case .gs: return UIColor(hex: "#00D7F1")
    case .sevenEleven: return UIColor(hex: "#005B45")
    case .miniStop: return UIColor(hex: "#F0F0F0")
    case .eMart: return UIColor(hex: "#FFB41D")
    case .all: return UIColor.white
    }
  }
}
