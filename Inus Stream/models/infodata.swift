//
//  infodata.swift
//  Inus Stream
//
//  Created by Inumaki on 07.11.22.
//

import Foundation

struct InfoData: Codable {
    let id: String
    let title: Title
    let malId: Int?
    let synonyms: [String]?
    let isLicensed, isAdult: Bool?
    let countryOfOrigin: String?
    let trailer: Trailer?
    let image: String
    let popularity: Int
    let color: String?
    let cover: String
    let description, status: String
    let releaseDate: Int
    let startDate, endDate: Date
    let nextAiringEpisode: AiringData?
    let totalEpisodes: Int?
    let duration: Int?
    let rating: Int?
    let genres: [String]
    let season: String?
    let studios: [String]
    let subOrDub: String
    let type: String?
    let recommendations: [Recommended]?
    let characters: [Character]
    let relations: [Related]?
    let episodes: [Episode]?
}
