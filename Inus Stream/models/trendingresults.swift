//
//  trendingresults.swift
//  Inus Stream
//
//  Created by Inumaki on 07.11.22.
//

import Foundation

struct TrendingResults: Codable, Hashable {
    let currentPage: Int
    let hasNextPage: Bool
    let results: [TrendingData]
}
