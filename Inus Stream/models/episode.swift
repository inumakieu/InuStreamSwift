//
//  episode.swift
//  Inus Stream
//
//  Created by Inumaki on 07.11.22.
//

import Foundation

struct Episode: Codable, Identifiable {
    let id: String
    let title: String?
    let description: String?
    let number: Int?
    let image: String
    let isFiller: Bool?
}
