//
//  InfoPage.swift
//  Inus Stream
//
//  Created by Inumaki on 26.09.22.
//

import SwiftUI

struct InfoPage: View {
    @StateObject var infoApi = InfoApi()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color(hex: "#ff16151A")
                    .ignoresSafeArea()
                
                if(infoApi.infodata != nil) {
                    ScrollView {
                        ZStack(alignment: .bottom) {
                            AsyncImage(url: URL(string: infoApi.infodata!.cover)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 390, height: 440)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            Rectangle()
                                .fill(LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: Color(hex: "#0016151A"), location: 0),
                                        .init(color: Color(hex: "#9016151A"), location: 0.5),
                                        .init(color: Color(hex: "#ff16151A"), location: 1)
                                    ]),
                                    startPoint: UnitPoint(x: 0.0, y: 0),
                                    endPoint: UnitPoint(x: 0.0, y: 1)))
                                .frame(width: 394, height: 440)
                                .ignoresSafeArea()
                            
                            AsyncImage(url: URL(string: infoApi.infodata!.image)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 176, height: 270)
                                    .cornerRadius(20)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        
                        Text(infoApi.infodata!.title.english ?? infoApi.infodata!.title.romaji)
                            .bold()
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.top, 14)
                        Text(infoApi.infodata!.title.native)
                            .bold()
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        ZStack {
                            Color(hex: "#ff1E222C")
                            Text(infoApi.infodata!.description)
                                .foregroundColor(.white)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .padding(.all, 20)
                        }
                        .frame(maxWidth: 350)
                        .cornerRadius(20)
                        .padding(.all, 20)
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 12) {
                                ForEach(0..<infoApi.infodata!.genres.count) {genre in
                                    ZStack {
                                        Color(.black)
                                        Text(infoApi.infodata!.genres[genre])
                                            .foregroundColor(.white)
                                            .bold()
                                            .font(.caption)
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 12)
                                    }
                                    .cornerRadius(40)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Text("Episodes")
                            .foregroundColor(.white)
                            .font(.title)
                            .bold()
                            .frame(maxWidth: 340, alignment: .leading)
                            .padding(.top, 10)
                        
                        VStack(spacing: 18) {
                            ForEach(0..<infoApi.infodata!.episodes.count) {index in
                                EpisodeCard(title: infoApi.infodata!.episodes[index].title, number: infoApi.infodata!.episodes[index].number, thumbnail: infoApi.infodata!.episodes[index].image)
                            }
                        }
                        .frame(maxWidth: 350, alignment: .leading)
                    }
                    .ignoresSafeArea()
                }
                
            }
            .onAppear() {
                infoApi.loadInfo()
        }
        }
        
    }
}

struct InfoPage_Previews: PreviewProvider {
    static var previews: some View {
        InfoPage()
    }
}

class InfoApi : ObservableObject{
    @Published var infodata: InfoData? = nil
    
    func loadInfo() {
        guard let url = URL(string: "https://consumet-api.herokuapp.com/meta/anilist/info/98659?provider=zoro") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let books = try! JSONDecoder().decode(InfoData.self, from: data!)
            print(books)
            DispatchQueue.main.async {
                self.infodata = books
            }
        }.resume()
    }
}

struct InfoData: Codable {
    let id: String
    let title: Title
    let malId: Int?
    let synonyms: [String]
    let isLicensed, isAdult: Bool
    let countryOfOrigin: String
    let trailer: Trailer
    let image: String
    let popularity: Int
    let color: String
    let cover: String
    let description, status: String
    let releaseDate: Int
    let startDate, endDate: EndDateClass
    let totalEpisodes, rating, duration: Int
    let genres: [String]
    let season: String
    let studios: [String]
    let subOrDub, type: String
    let recommendations: [Recommended]?
    let characters: [Character]
    let relations: [Related]
    let episodes: [Episode]
}

struct Recommended: Codable {
    let id: Int
    let malId: Int?
    let title: Title
    let status: String
    let episodes: Int
    let image, cover: String
    let rating: Int
    let type: String
}

struct Character: Codable {
    let id: Int
    let role: String
    let name: Name
    let image: String
    let voiceActors: [VoiceActor]?
}

struct Related: Codable {
    let id: Int
    let relationType: String
    let malId: Int?
    let title: Title
    let status: String
    var episodes: Int?
    let image: String
    let color, type: String
    let cover: String
    let rating: Int
}

struct Episode: Codable {
    let id: String
    let title: String
    let description: String
    let number: Int
    let image: String
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
    let year, month, day: Int
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
