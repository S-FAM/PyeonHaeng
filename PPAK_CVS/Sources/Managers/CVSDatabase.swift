//
//  CVSDatabase.swift
//  PPAK_CVS
//
//  Created by 홍승현 on 2022/11/04.
//

import Foundation

import FirebaseFirestore

final class CVSDatabase {

  /// The shared singleton firebase object.
  static let shared: CVSDatabase = CVSDatabase()

  private lazy var db = Firestore.firestore().collection("sale")

//  var isSynchronized: Bool {
//    db.document("sync_key")
//  }

}
