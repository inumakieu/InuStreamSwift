//
//  recentresults.swift
//  Inus Stream
//
//  Created by Inumaki on 07.11.22.
//

import Foundation

struct RecentResults: Codable, Hashable {
    let currentPage: Int
    let hasNextPage: Bool
    let totalPages: Int
    let totalResults: Int
    let results: [RecentData]
}
