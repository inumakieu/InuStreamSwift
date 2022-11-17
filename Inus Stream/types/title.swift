//
//  title.swift
//  Inus Stream
//
//  Created by Inumaki on 07.11.22.
//

import Foundation

struct Title: Codable, Hashable {
    let romaji: String
    var english: String?
    let native: String?
    var userPreferred: String?
}
