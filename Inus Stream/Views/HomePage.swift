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
    @StateObject var infoApi = InfoApi()
    let tempString = "NO TITLE"
    @Environment(\.presentationMode) var presentation
    @Environment(\.managedObjectContext) var storage
    @FetchRequest(sortDescriptors: []) var animeStorageData: FetchedResults<AnimeStorageData>
    @State var canNavigate: Bool = false
    @State var tempData: InfoData? = nil
    @State private var sheetShown = false
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()

        UINavigationBar.appearance().standardAppearance = appearance
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        if #available(iOS 16.0, *) {
            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
        } else {
            // Fallback on earlier versions
        }
    }
    
    var body: some View {
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        if #available(iOS 16.0, *) {
            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
        } else {
            // Fallback on earlier versions
        }
        
        return NavigationView {
                ZStack(alignment: .top) {
                    Color(hex: "#ff16151A")
                        .ignoresSafeArea()
                    if(api.books.count > 0) {
                        ScrollView {
                            VStack {
                                TabView() {
                                    ForEach(api.books) { anime in
                                        ExtractedView(item: anime)
                                            .frame(maxWidth: .infinity)
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
                                HStack(spacing: 14) {
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
                                HStack(alignment: .top, spacing: 20) {
                                    ForEach(animeStorageData) {data in
                                        NavigationLink(destination: WatchPage(aniData: infoApi.infodata, episodeIndex: Int(data.episodeNumber) - 1, anilistId: data.id), isActive: $canNavigate) {
                                            ContinueWatching(image: data.episodeThumbnail ?? "https://artworks.thetvdb.com/banners/episodes/329822/6125438.jpg", progress: data.episodeProgress ?? 0.0, title: data.animeTitle!, currentTime: data.currentTime, duration: data.duration, number: data.episodeNumber)
                                        }.simultaneousGesture(TapGesture().onEnded {
                                            // get data
                                            infoApi.loadInfo(id: data.id!)
                                            
                                            if(infoApi.infodata == nil) {
                                                canNavigate = false
                                            } else {
                                                canNavigate = true
                                            }
                                            //canNavigate = infoApi.infodata != nil
                                        })
                                    }
                                }
                            }
                            .padding(.horizontal, 30)
                            .frame(height: 240, alignment: .top)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 20)
                            
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
                                    .frame(maxWidth: .infinity)
                                
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
                                HStack(alignment: .top, spacing: 0) {
                                    ForEach(0..<5) {_ in
                                        ContinueWatching(image: "", progress: 0.0, title: "", currentTime: 0.0, duration: 0.0, number: 1)
                                    }
                                }
                            }
                            .padding(.horizontal, 30)
                            .frame(height: 260, alignment: .top)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 0)
                            
                            Spacer()
                                .frame(height: 100)
                                .frame(maxHeight: 100)
                            
                        }
                        .ignoresSafeArea()
                        .redacted(reason: .placeholder).shimmering(active: true)
                    }
                    
                        
                    NavigationLink(destination: SearchPage()) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                        }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal, 20)
                        .padding(.top, 12)
                    }
                }
            
        }
        .accentColor(.white)
        .onAppear() {
            api.loadData()
            api.loadRecent()
        }
            
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

struct ExtractedView: View {
    let item: IAnimeInfo
    @State private var isShowingDeviceDetail = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            AsyncImage(url: URL(string: "\(item.cover!)")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: .infinity, height: 500)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
            } placeholder: {
                ProgressView()
            }
            .frame(width: .infinity, height: 500)
            .frame(maxWidth: .infinity)
            
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(hex: "#0016151A"), location: 0),
                        .init(color: Color(hex: "#9016151A"), location: 0.5),
                        .init(color: Color(hex: "#ff16151A"), location: 1)
                    ]),
                    startPoint: UnitPoint(x: 0.0, y: 0),
                    endPoint: UnitPoint(x: 0.0, y: 1)))
                .frame(width: .infinity, height: 500)
                .frame(maxWidth: .infinity)
            
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
                Text("\(item.title.english ?? item.title.romaji)")
                    .bold()
                    .font(.title)
                    .frame(maxWidth: 350, alignment: .leading)
                    .multilineTextAlignment(.leading)
                
                Text(.init("\(item.description!.replacingOccurrences(of: "<br>", with: "").replacingOccurrences(of: "_", with: "").replacingOccurrences(of: "<i>", with: "_").replacingOccurrences(of: "</i>", with: "_").replacingOccurrences(of: "_ ", with: "_"))"))
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
            .frame(maxWidth: .infinity)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        
    }
}

struct ShimmerView: View {
    
    var body: some View {
        ZStack(alignment: .leading) {
            AsyncImage(url: URL(string: "https://s4.anilist.co/file/anilistcdn/media/anime/banner/98659-u46B5RCNl9il.jpg")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: .infinity, height: 500)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
            } placeholder: {
                ProgressView()
            }
            .frame(width: .infinity, height: 500)
            .frame(maxWidth: .infinity)
            
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(hex: "#0016151A"), location: 0),
                        .init(color: Color(hex: "#9016151A"), location: 0.5),
                        .init(color: Color(hex: "#ff16151A"), location: 1)
                    ]),
                    startPoint: UnitPoint(x: 0.0, y: 0),
                    endPoint: UnitPoint(x: 0.0, y: 1)))
                .frame(width: .infinity, height: 500)
                .frame(maxWidth: .infinity)
            
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
            .frame(maxWidth: .infinity)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
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