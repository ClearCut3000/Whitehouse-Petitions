//
//  Petition.swift
//  Whitehouse Petitions
//
//  Created by Николай Никитин on 17.12.2021.
//

import Foundation
struct Petition: Codable {
  var title: String
  var body: String
  var signatureCount: Int
}
