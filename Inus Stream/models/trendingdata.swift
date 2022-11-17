//
//  trendingdata.swift
//  Inus Stream
//
//  Created by Inumaki on 07.11.22.
//

import Foundation

struct TrendingData: Codable, Hashable, Identifiable {
    let id: String
    let malId: Int?
    let title: Title
    let image: String
    let description: String?
    let status: String
    let cover: String?
    let rating: Int?
    let releaseDate: Int?
    let genres: [String]
    let totalEpisodes: Int?
    let duration: Int?
    let type: String?
}
