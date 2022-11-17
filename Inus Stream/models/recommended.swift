//
//  recommended.swift
//  Inus Stream
//
//  Created by Inumaki on 07.11.22.
//

import Foundation

struct Recommended: Codable {
    let id: Int?
    let malId: Int?
    let title: Title
    let status: String
    let episodes: Int?
    let image, cover: String
    let rating: Int?
    let type: String?
}
