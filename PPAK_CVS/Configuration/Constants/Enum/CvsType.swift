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

enum CVSType {

  case cu // cu
  case gs // gs25
  case sevenEleven // sevenEleven
  case miniStop // miniStop
  case eMart // eMart

  var title: String {
    switch self {
    case .cu: return "CU"
    case .gs: return "GS25"
    case .sevenEleven: return "7-ELEVEn"
    case .miniStop: return "MINISTOP"
    case .eMart: return "emart24"
    }
  }

  // TODO: - 나중에 정확한 파일명으로 수정필요
  var image: UIImage? {
    switch self {
    case .cu: return UIImage(systemName: "CU")
    case .gs: return UIImage(systemName: "GS25")
    case .sevenEleven: return UIImage(systemName: "7-ELEVEn")
    case .miniStop: return UIImage(systemName: "MINISTOP")
    case .eMart: return UIImage(systemName: "emart24")
    }
  }

  // TODO: - 머지후 정확한 컬러로 수정필요
  var bgColor: UIColor {
    switch self {
    case .cu: return UIColor(hex: 0x51485)
    case .gs: return UIColor(hex: 0x63514D)
    case .sevenEleven: return UIColor(hex: 0xFF8329)
    case .miniStop: return UIColor(hex: 0x003893)
    case .eMart: return UIColor(hex: 0x56555B)
    }
  }

  // TODO: - 머지후 정확한 컬러로 수정필요
  var fontColor: UIColor {
    switch self {
    case .cu: return UIColor(hex: 0x9DC92A)
    case .gs: return UIColor(hex: 0x00D7F1)
    case .sevenEleven: return UIColor(hex: 0x005B45)
    case .miniStop: return UIColor(hex: 0xF0F0F0)
    case .eMart: return UIColor(hex: 0xFFB41D)
    }
  }
}
