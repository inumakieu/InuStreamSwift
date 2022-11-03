//
//  Anilist.swift
//  Inus Stream
//
//  Created by Inumaki on 25.10.22.
//

import Foundation

class Anilist : ObservableObject{
    @Published var trendingData = [IAnimeInfo]()
    @Published var recentsData = [IAnimeRecent]()
    @Published var infodata: InfoData? = nil
    
    let baseUrl: String = "https://api.consumet.org"
    
    func getTrending() {
        guard let url = URL(string: "\(baseUrl)/meta/anilist/trending") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let trending = try! JSONDecoder().decode(TrendingResults.self, from: data!)
            DispatchQueue.main.async {
                self.trendingData = trending.results
            }
        }.resume()
    }
    
    func getRecents() {
        guard let url = URL(string: "\(baseUrl)/meta/anilist/recent-episodes") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let recents = try! JSONDecoder().decode(RecentResults.self, from: data!)
            DispatchQueue.main.async {
                self.recentsData = recents.results
            }
        }.resume()
    }
    
    func getInfo(id: String) {
        guard let url = URL(string: "\(baseUrl)/meta/anilist/info/\(id)?fetchFiller=true") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let info = try! JSONDecoder().decode(InfoData.self, from: data!)
            DispatchQueue.main.async {
                self.infodata = info
            }
        }.resume()
    }
}

struct TrendingResults: Codable, Hashable {
    let currentPage: Int
    let hasNextPage: Bool
    let results: [IAnimeInfo]
}

struct RecentResults: Codable, Hashable {
    let currentPage: Int
    let hasNextPage: Bool
    let totalPages: Int
    let totalResults: Int
    let results: [IAnimeRecent]
}

struct IAnimeInfo: Codable, Hashable, Identifiable {
    let id: String
    let malId: Int?
    let title: ITitle
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

struct IAnimeRecent: Codable, Hashable, Identifiable {
    let id: String
    let malId: Int?
    let title: ITitle
    let image: String
    let rating: Int?
    let color: String?
    let episodeId: String
    let episodeTitle: String
    let episodeNumber: Int
    let genres: [String]
    let type: String
}

struct ITitle: Codable, Hashable {
    let romaji: String
    var english: String?
    let native: String?
    var userPreferred: String?
}

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
    let startDate, endDate: EndDateClass
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

struct AiringData: Codable {
    let airingTime: Int
    let timeUntilAiring: Int
    let episode: Int
}

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

struct Character: Codable {
    let id: Int?
    let role: String
    let name: Name
    let image: String
    let voiceActors: [VoiceActor]?
}

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

struct Episode: Codable, Identifiable {
    let id: String
    let title: String?
    let description: String?
    let number: Int?
    let image: String
    let isFiller: Bool?
}

// MARK: - Name
struct Name: Codable {
    let first, last, full: String?
    let native: String?
    let userPreferred: String
}

// MARK: - VoiceActor
struct VoiceActor: Codable {
    let id: Int
    let name: Name
    let image: String
}

// MARK: - EndDateClass
struct EndDateClass: Codable {
    let year: Int?
    let month: Int?
    let day: Int?
}

// MARK: - Title
struct Title: Codable {
    let romaji, native: String
    let english: String?
}

// MARK: - Trailer
struct Trailer: Codable {
    let id, site: String
    let thumbnail: String
}
