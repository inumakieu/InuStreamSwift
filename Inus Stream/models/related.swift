//
//  related.swift
//  Inus Stream
//
//  Created by Inumaki on 07.11.22.
//

import Foundation

struct Related: Codable {
    let id: Int?
    let relationType: String
    let malId: Int?
    let title: Title
    let status: String
    var episodes: Int?
    let image: String
    let color, type: String?
    let cover: String
    let rating: Int?
}
