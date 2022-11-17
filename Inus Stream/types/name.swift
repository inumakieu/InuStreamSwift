//
//  name.swift
//  Inus Stream
//
//  Created by Inumaki on 07.11.22.
//

import Foundation

struct Name: Codable {
    let first, last, full: String?
    let native: String?
    let userPreferred: String
}
