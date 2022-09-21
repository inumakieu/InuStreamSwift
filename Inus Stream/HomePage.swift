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
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                Color(red: 22/255, green: 21/255, blue: 26/255)
                    .ignoresSafeArea()
                ScrollView {
                        HStackSnap(alignment: .leading(0)) {
                            ForEach(0..<3) {index in
                                ZStack(alignment: .leading) {
                                    AsyncImage(url: URL(string: "https://s4.anilist.co/file/anilistcdn/media/anime/banner/98659-u46B5RCNl9il.jpg")) { image in
                                        image.resizable()
                                            .blur(radius: 3)
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: proxy.size.width + 40, height: 500)
                                            .cornerRadius(12)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .ignoresSafeArea()
                                    
                                    Rectangle()
                                        .fill(LinearGradient(
                                                gradient: Gradient(stops: [
                                            .init(color: Color(#colorLiteral(red: 0.08627450466156006, green: 0.08235294371843338, blue: 0.10196078568696976, alpha: 0)), location: 0),
                                            .init(color: Color(#colorLiteral(red: 0.08627450466156006, green: 0.08235294371843338, blue: 0.10196078568696976, alpha: 0.7099999785423279)), location: 0.5052083134651184),
                                            .init(color: Color(#colorLiteral(red: 0.08627451211214066, green: 0.08235294371843338, blue: 0.10196078568696976, alpha: 1)), location: 1)]),
                                                startPoint: UnitPoint(x: 0.5, y: -3.061617214180981e-17),
                                                endPoint: UnitPoint(x: 0.5, y: 0.9999999999999999)))
                                        .frame(width: proxy.size.width + 40, height: 500)
                                    .ignoresSafeArea()
                                    
                                    VStack(alignment: .leading) {
                                        Text("24 min / Episodes")
                                            .fontWeight(.semibold)
                                            .font(.caption)
                                        Text("Episodes: 12 - Status: FINISHED")
                                            .fontWeight(.semibold)
                                            .font(.subheadline)
                                        Text("Classroom of the Elite")
                                            .bold()
                                            .font(.title)
                                        Text("Koudo Ikusei Senior High School is a leading school with state-of-the-art facilities. The students there have the freedom to wear any hairstyle and bring any personal effects they desire. Koudo Ikusei is like a utopia, but the truth is that only the most superior students receive favorable treatment.\n\nKiyotaka Ayanokouji is a student of D-class, which is where the school dumps its \"inferior\" students in order to ridicule them. For a certain reason, Kiyotaka was careless on his entrance examination, and was put in D-class. After meeting Suzune Horikita and Kikyou Kushida, two other students in his class, Kiyotaka's situation begins to change.\n(Source: Anime News Network, edited)")
                                            .fontWeight(.medium)
                                            .font(.footnote)
                                            .lineLimit(10)
                                            .frame(width: proxy.size.width - 40)
                                            .padding(.top, -14)
                                            .padding(.bottom, 8)
                                            .padding(.leading, 0)
                                        
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 35)
                                            .fill(Color(#colorLiteral(red: 0.10196078568696976, green: 0.6823529601097107, blue: 0.9960784316062927, alpha: 1)))
                                            .frame(width: 109, height: 43)
                                            
                                            Text("INFO")
                                                .font(.subheadline)
                                                .bold()
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                            
                                        }
                                        .padding(.leading, 20)
                                        
                                    }
                                    .foregroundColor(.white)
                                    .frame(width: proxy.size.width, height: 500, alignment: .bottom)
                                    .padding(.bottom, 20)
                                }
                                .snapAlignmentHelper(id: index)
                            }
                        }
                        .frame(width: proxy.size.width, height: 500, alignment: .bottom)
                        .onAppear() {
                            api.loadData()
                        }
                    
                    
                    Text("Recently Released")
                        .foregroundColor(.white)
                        .bold()
                        .font(.title2)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .frame(width: proxy.size.width, alignment: .leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 30) {
                            ForEach(0..<5) {_ in
                                RecentAnimeCard()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(width: proxy.size.width, height: 300)
                    
                }
                .ignoresSafeArea()
                .padding(.top, -60)
            }
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
    
    func loadData() {
        guard let url = URL(string: "https://consumet-api.herokuapp.com/meta/anilist/trending?provider=zoro") else {
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
}

struct TrendingResults: Codable {
    let currentPage: Int
    let hasNextPage: Bool
    let results: [IAnimeInfo]
}

struct IAnimeInfo: Codable {
    let id: String
    let malId: Int
    let title: ITitle
    let image: String
    let description: String
    let status: String
    let cover: String
    let rating: Int
    let releaseDate: Int
    let genres: [String]
    let totalEpisodes: Int
    let duration: Int
    let type: String
}

struct ITitle: Codable {
    let romaji: String
    var english: String?
    let native: String
    var userPreferred: String?
}
