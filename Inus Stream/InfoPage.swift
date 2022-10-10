//
//  InfoPage.swift
//  Inus Stream
//
//  Created by Inumaki on 26.09.22.
//

import SwiftUI
import Shimmer

struct InfoPage: View {
    let anilistId: String
    @StateObject var infoApi = InfoApi()
    @Environment(\.presentationMode) var presentation
    
    init(anilistId: String) {
        self.anilistId = anilistId
    }
    
    func getAiringTime(airingTime: Int) -> String {
        // convert seconds into days and hours
        let hours = airingTime / 60 / 60
        let days = hours / 24
        
        // return days if time is longer than one day
        if(days >= 1) {
            return String(days) + " days"
        } else {
            // return hours if time is less than one day
            return String(hours) + " hours"
        }
        
    }
    
    var body: some View {
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        if #available(iOS 16.0, *) {
            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
        } else {
            // Fallback on earlier versions
        }
        return ZStack(alignment: .top) {
                Color(hex: "#ff16151A")
                    .ignoresSafeArea()
                
                if(infoApi.infodata != nil) {
                    ScrollView(showsIndicators: false) {
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
                                .frame(height: 440)
                                .frame(maxWidth: .infinity)
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
                            .multilineTextAlignment(.center)
                            .padding(.top, 14)
                        Text(infoApi.infodata!.title.native)
                            .bold()
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        ZStack {
                            Color(hex: "#ff1E222C")
                            Text(.init(infoApi.infodata!.description.replacingOccurrences(of: "<br>", with: "").replacingOccurrences(of: "<i>", with: "_").replacingOccurrences(of: "</i>", with: "_")))
                                .foregroundColor(.white)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .padding(.all, 20)
                        }
                        .frame(maxWidth: 350)
                        .cornerRadius(20)
                        .padding(.all, 20)
                        
                        HStack {
                            ScrollView(.horizontal) {
                                HStack(spacing: 12) {
                                    ForEach(0..<infoApi.infodata!.genres.count) {genre in
                                        ZStack {
                                            Color(.black)
                                            Text(infoApi.infodata!.genres[genre])
                                                .foregroundColor(.white)
                                                .bold()
                                                .font(.caption)
                                                .bold()
                                                .padding(.horizontal, 20)
                                                .padding(.vertical, 12)
                                        }
                                        .frame(height: 32)
                                        .cornerRadius(40)
                                    }
                                }
                            }
                            if(infoApi.infodata?.nextAiringEpisode != nil) {
                                ZStack {
                                    Color(hex: "#ffEE4546")
                                    Text("Next Episode: \(getAiringTime(airingTime: infoApi.infodata!.nextAiringEpisode!.timeUntilAiring))")
                                        .bold()
                                        .font(.caption)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                }
                                .frame(height: 40)
                                .frame(maxWidth: 100)
                                .cornerRadius(12)
                            }
                            
                        }
                        
                        .padding(.horizontal, 20)
                        
                        Text("Episodes")
                            .foregroundColor(.white)
                            .font(.title)
                            .bold()
                            .frame(maxWidth: 340, alignment: .leading)
                            .padding(.top, 10)
                        
                        ScrollView {
                            VStack(spacing: 18) {
                                ForEach(0..<infoApi.infodata!.episodes!.count) {index in
                                    EpisodeCard(animeData: infoApi.infodata!,title: infoApi.infodata!.episodes![index].title ?? infoApi.infodata!.title.romaji, number: infoApi.infodata!.episodes![index].number, thumbnail: infoApi.infodata!.episodes![index].image, isFiller: infoApi.infodata!.episodes![index].isFiller
                                                )
                                    .contextMenu {
                                        VStack {
                                            Button(action: {
                                                // set this episode as watched
                                                
                                            }) {
                                                HStack {
                                                    Text("Mark as watched")
                                                    
                                                    Image(systemName: "eye.fill")
                                                }
                                            }
                                            Button(action: {}) {
                                                HStack {
                                                    Text("Set to current Episode")
                                                    
                                                    Image(systemName: "eye.fill")
                                                }
                                            }
                                        }
                                    }
                                }
                                Spacer()
                                    .frame(maxHeight: 100)
                            }
                        .frame(maxWidth: 350, alignment: .leading)
                        }
                        .frame(height: 500)
                    }
                    .ignoresSafeArea()
                }
                else {
                    ScrollView {
                        ZStack(alignment: .bottom) {
                            AsyncImage(url: URL(string: "https://s4.anilist.co/file/anilistcdn/media/anime/banner/98659-u46B5RCNl9il.jpg")) { image in
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
                            
                            AsyncImage(url: URL(string: "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/b98659-sH5z5RfMuyMr.png")) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 176, height: 270)
                                    .cornerRadius(20)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        
                        Text("Classroom of the Elite")
                            .bold()
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.top, 14)
                        Text("ようこそ実力至上主義の教室へ")
                            .bold()
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        ZStack {
                            Color(hex: "#ff1E222C")
                            Text("Koudo Ikusei Senior High School is a leading school with state-of-the-art facilities. The students there have the freedom to wear any hairstyle and bring any personal effects they desire. Koudo Ikusei is like a utopia, but the truth is that only the most superior students receive favorable treatment.<br><br>\n\nKiyotaka Ayanokouji is a student of D-class, which is where the school dumps its \"inferior\" students in order to ridicule them. For a certain reason, Kiyotaka was careless on his entrance examination, and was put in D-class. After meeting Suzune Horikita and Kikyou Kushida, two other students in his class, Kiyotaka's situation begins to change. <br><br>\n(Source: Anime News Network, edited)")
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
                                ForEach(0..<3) {genre in
                                    ZStack {
                                        Color(.black)
                                        Text("GENRE")
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
                        
                        ScrollView {
                            VStack(spacing: 18) {
                                ForEach(0..<5) {index in
                                    EpisodeCard(animeData: nil,title: "Hell is other people.", number: 1, thumbnail: "https://artworks.thetvdb.com/banners/episodes/329822/6190201.jpg", isFiller: false)
                                }
                            }
                        .frame(maxWidth: 350, alignment: .leading)
                        }
                        .frame(maxHeight: 500)
                    }
                    .ignoresSafeArea()
                    .redacted(reason: .placeholder).shimmering(active: true)
                }
                
                Button(action: {
                    self.presentation.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundColor(.white)
                })
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.leading, 20)
            }
            .onAppear() {
                infoApi.loadInfo(id: anilistId)
        }
            .navigationBarBackButtonHidden(true)
                
                .contentShape(Rectangle()) // Start of the gesture to dismiss the navigation
                .gesture(
                  DragGesture(coordinateSpace: .local)
                    .onEnded { value in
                      if value.translation.width > .zero
                          && value.translation.height > -30
                          && value.translation.height < 30 {
                        presentation.wrappedValue.dismiss()
                      }
                    }
                )
        
                
        
    }
}

struct InfoPage_Previews: PreviewProvider {
    static var previews: some View {
        InfoPage(anilistId: "130298")
    }
}

class InfoApi : ObservableObject{
    @Published var infodata: InfoData? = nil
    
    func loadInfo(id: String) {
        guard let url = URL(string: "https://api.consumet.org/meta/anilist/info/\(id)?fetchFiller=true") else {
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
    let synonyms: [String]?
    let isLicensed, isAdult: Bool?
    let countryOfOrigin: String?
    let trailer: Trailer?
    let image: String
    let popularity: Int
    let color: String
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
    let subOrDub, type: String
    let recommendations: [Recommended]?
    let characters: [Character]
    let relations: [Related]
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
    let type: String
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
    let color, type: String
    let cover: String
    let rating: Int?
}

struct Episode: Codable {
    let id: String
    let title: String?
    let description: String?
    let number: Int
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
