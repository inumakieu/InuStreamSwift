//
//  recentdata.swift
//  Inus Stream
//
//  Created by Inumaki on 07.11.22.
//

import Foundation

struct RecentData: Codable, Hashable, Identifiable {
    let id: String
    let malId: Int?
    let title: Title
    let image: String
    let rating: Int?
    let color: String?
    let episodeId: String
    let episodeTitle: String
    let episodeNumber: Int
    let genres: [String]
    let type: String
}
