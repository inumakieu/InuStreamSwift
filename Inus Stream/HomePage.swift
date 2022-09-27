//
//  HomePage.swift
//  Inus Stream
//
//  Created by L Lawliet on 19.09.22.
//

import SwiftUI
import SnapToScroll

struct HomePage: View {
    @StateObject var api = Api()
    let tempString = "NO TITLE"
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color(hex: "#ff16151A")
                    .ignoresSafeArea()
                if(api.books.count > 0) {
                    ScrollView {
                        VStack {
                            TabView() {
                                ForEach(api.books) { anime in
                                    ExtractedView(item: anime)
                                        .frame(maxWidth: 390)
                                }
                            }.tabViewStyle(.page(indexDisplayMode: .never))
                                .indexViewStyle(.page(backgroundDisplayMode: .always))
                            
                        }.frame(height: 500, alignment: .bottom)
                            .frame(maxWidth: .infinity)
                        
                        
                        
                        
                        Text("Recently Added")
                            .foregroundColor(.white)
                            .bold()
                            .font(.title2)
                            .padding(.horizontal, 30)
                            .padding(.top, 30)
                            .padding(.bottom, -12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(api.recents) {recentAnime in
                                    RecentAnimeCard(anime: recentAnime)
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                        .frame(height: 300)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 0)
                        
                        Text("Continue watching")
                            .foregroundColor(.white)
                            .bold()
                            .font(.title2)
                            .padding(.horizontal, 30)
                            .padding(.top, 0)
                            .padding(.bottom, -12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(0..<5) {_ in
                                    ContinueWatching()
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                        .frame(height: 220)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 0)
                        
                        Spacer()
                            .frame(height: 100)
                            .frame(maxHeight: 100)
                        
                    }
                    .ignoresSafeArea()
                    .padding(.top, -70)
                } else {
                    ScrollView {
                        VStack {
                            
                            ShimmerView()
                                .frame(maxWidth: 390)
                            
                        }.frame(height: 500, alignment: .bottom)
                            .frame(maxWidth: .infinity)
                        
                        
                        
                        
                        Text("Recently Added")
                            .foregroundColor(.white)
                            .bold()
                            .font(.title2)
                            .padding(.horizontal, 30)
                            .padding(.top, 30)
                            .padding(.bottom, -12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(0..<5) {_ in
                                    RecentAnimeCard(anime: IAnimeRecent(id: "140085",
                                                                        malId: 50060,
                                                                        title: ITitle(
                                                                          romaji: "Shadowverse Flame",
                                                                          english: "Shadowverse Flame",
                                                                          native: "シャドウバースF（フレイム）",
                                                                          userPreferred: "Shadowverse Flame"
                                                                        ),
                                                                        image: "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx140085-3VhIbUc8HKYi.jpg",
                                                                        rating: 57,
                                                                        color: "#e48628",
                                                                        episodeId: "cl8fcg82200042gpk1itl8sgf-enime",
                                                                        episodeTitle: "The Shadowverse Club Tournament Begins!",
                                                                        episodeNumber: 26,
                                                                        genres: [
                                                                          "Fantasy"
                                                                        ],
                                                                        type: "TV"))
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                        .frame(height: 300)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 0)
                        
                        Text("Continue watching")
                            .foregroundColor(.white)
                            .bold()
                            .font(.title2)
                            .padding(.horizontal, 30)
                            .padding(.top, 0)
                            .padding(.bottom, -12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(0..<5) {_ in
                                    ContinueWatching()
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                        .frame(height: 220)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 0)
                        
                        Spacer()
                            .frame(height: 100)
                            .frame(maxHeight: 100)
                        
                    }
                    .ignoresSafeArea()
                    .redacted(reason: .placeholder).shimmering(active: true)
                }
                
                VStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                            .frame(width: 350, height: 70)
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), radius:12, x:0, y:0)
                        
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(hex: "#ff1E222C"))
                                    .frame(width: 90, height: 40)
                                
                                Text("Home")
                                    .bold()
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 19)
                                    .fill(Color(hex: "#001E222C"))
                                    .frame(width: 90, height: 40)
                                
                                Text("Search")
                                    .bold()
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 19)
                                    .fill(Color(hex: "#001E222C"))
                                    .frame(width: 90, height: 40)
                                
                                Text("Settings")
                                    .bold()
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            
                        }
                        .frame(width: 300)
                    }
                }
            }.onAppear() {
                api.loadData()
                api.loadRecent()
            }
        }.accentColor(.white)
    }
    
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}

class Api : ObservableObject{
    @Published var books = [IAnimeInfo]()
    @Published var recents = [IAnimeRecent]()
    
    func loadData() {
        guard let url = URL(string: "https://api.consumet.org/meta/anilist/trending") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let books = try! JSONDecoder().decode(TrendingResults.self, from: data!)
            print(books)
            DispatchQueue.main.async {
                self.books = books.results
            }
        }.resume()
    }
    
    func loadRecent() {
        guard let url = URL(string: "https://api.consumet.org/meta/anilist/recent-episodes") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let books = try! JSONDecoder().decode(RecentResults.self, from: data!)
            print(books)
            DispatchQueue.main.async {
                self.recents = books.results
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
    let description: String
    let status: String
    let cover: String
    let rating: Int?
    let releaseDate: Int?
    let genres: [String]
    let totalEpisodes: Int?
    let duration: Int?
    let type: String
}

struct IAnimeRecent: Codable, Hashable, Identifiable {
    let id: String
    let malId: Int?
    let title: ITitle
    let image: String
    let rating: Int?
    let color: String
    let episodeId: String
    let episodeTitle: String
    let episodeNumber: Int
    let genres: [String]
    let type: String
}

struct ITitle: Codable, Hashable {
    let romaji: String
    var english: String?
    let native: String
    var userPreferred: String?
}

struct ExtractedView: View {
    let item: IAnimeInfo
    @State private var isShowingDeviceDetail = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            AsyncImage(url: URL(string: "\(item.cover)")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 390, height: 500)
                    .frame(maxWidth: 390)
                    .cornerRadius(12)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 390, height: 500)
            .frame(maxWidth: 390)
            
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(hex: "#0016151A"), location: 0),
                        .init(color: Color(hex: "#9016151A"), location: 0.5),
                        .init(color: Color(hex: "#ff16151A"), location: 1)
                    ]),
                    startPoint: UnitPoint(x: 0.0, y: 0),
                    endPoint: UnitPoint(x: 0.0, y: 1)))
                .frame(width: 390, height: 500)
                .frame(maxWidth: 390)
            
            VStack(alignment: .leading) {
                Text("\(item.duration ?? 0) min / Episodes")
                    .fontWeight(.semibold)
                    .font(.caption)
                HStack {
                    Text("Episodes:")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                    Text("\(item.totalEpisodes ?? 0)")
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .font(.subheadline)
                    Text("- Status:")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                    Text("\(item.status)")
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .foregroundColor(.red)
                        .font(.subheadline)
                }
                Text("\(item.title.english!)")
                    .bold()
                    .font(.title)
                    .frame(maxWidth: 350, alignment: .leading)
                    .multilineTextAlignment(.leading)
                
                Text(.init("\(item.description.replacingOccurrences(of: "<br>", with: "").replacingOccurrences(of: "<i>", with: "_").replacingOccurrences(of: "</i>", with: "_"))"))
                    .fontWeight(.semibold)
                    .font(.footnote)
                    .lineSpacing(-3.0)
                    .lineLimit(10)
                    .frame(maxWidth: 350, alignment: .leading)
                    .padding(.top, -14)
                    .padding(.bottom, 8)
                    .padding(.leading, 0)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    NavigationLink(isActive: $isShowingDeviceDetail,destination: {InfoPage(anilistId: item.id)}) {
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 35)
                                .fill(Color(#colorLiteral(red: 0.10196078568696976, green: 0.6823529601097107, blue: 0.9960784316062927, alpha: 1)))
                                .frame(width: 109, height: 43)
                            
                            
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .font(Font.system(size: 24, weight: .bold))
                                
                                Text("INFO")
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                            }
                            
                        }
                        .onTapGesture {
                            isShowingDeviceDetail = true
                        }
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 21.5)
                            .fill(Color(.black))
                        .frame(width: 43, height: 43)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .heavy))
                    }
                    .padding(.trailing, 20)
                    
                    
                    
                }.frame(width: 350, height: 60)
                
                
            }
            .foregroundColor(.white)
            .frame(height: 500, alignment: .bottom)
            .frame(maxWidth: 390)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: 390)
    }
}

struct ShimmerView: View {
    
    var body: some View {
        ZStack(alignment: .leading) {
            AsyncImage(url: URL(string: "https://s4.anilist.co/file/anilistcdn/media/anime/banner/98659-u46B5RCNl9il.jpg")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 390, height: 500)
                    .frame(maxWidth: 390)
                    .cornerRadius(12)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 390, height: 500)
            .frame(maxWidth: 390)
            
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(hex: "#0016151A"), location: 0),
                        .init(color: Color(hex: "#9016151A"), location: 0.5),
                        .init(color: Color(hex: "#ff16151A"), location: 1)
                    ]),
                    startPoint: UnitPoint(x: 0.0, y: 0),
                    endPoint: UnitPoint(x: 0.0, y: 1)))
                .frame(width: 390, height: 500)
                .frame(maxWidth: 390)
            
            VStack(alignment: .leading) {
                Text("24 min / Episodes")
                    .fontWeight(.semibold)
                    .font(.caption)
                HStack {
                    Text("Episodes:")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                    Text("12")
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                        .font(.subheadline)
                    Text("- Status:")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                    Text("COMPLETED")
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .foregroundColor(.red)
                        .font(.subheadline)
                }
                Text("Classroom of the Elite")
                    .bold()
                    .font(.title)
                    .frame(maxWidth: 350, alignment: .leading)
                    .multilineTextAlignment(.leading)
                
                Text("Koudo Ikusei Senior High School is a leading school with state-of-the-art facilities. The students there have the freedom to wear any hairstyle and bring any personal effects they desire. Koudo Ikusei is like a utopia, but the truth is that only the most superior students receive favorable treatment.<br><br>\n\nKiyotaka Ayanokouji is a student of D-class, which is where the school dumps its \"inferior\" students in order to ridicule them. For a certain reason, Kiyotaka was careless on his entrance examination, and was put in D-class. After meeting Suzune Horikita and Kikyou Kushida, two other students in his class, Kiyotaka's situation begins to change. <br><br>\n(Source: Anime News Network, edited)")
                    .fontWeight(.semibold)
                    .font(.footnote)
                    .lineSpacing(-3.0)
                    .lineLimit(10)
                    .frame(maxWidth: 350, alignment: .leading)
                    .padding(.top, -14)
                    .padding(.bottom, 8)
                    .padding(.leading, 0)
                    .multilineTextAlignment(.leading)
                
                HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 35)
                                .fill(Color(#colorLiteral(red: 0.10196078568696976, green: 0.6823529601097107, blue: 0.9960784316062927, alpha: 1)))
                                .frame(width: 109, height: 43)
                            
                            
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .font(Font.system(size: 24, weight: .bold))
                                
                                Text("INFO")
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                            }
                            
                        }
                    .padding(.leading, 20)
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 21.5)
                            .fill(Color(.black))
                        .frame(width: 43, height: 43)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .heavy))
                    }
                    .padding(.trailing, 20)
                    
                    
                    
                }.frame(width: 350, height: 60)
                
                
            }
            .foregroundColor(.white)
            .frame(height: 500, alignment: .bottom)
            .frame(maxWidth: 390)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: 390)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
