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
            ZStack(alignment: .top) {
                Color(red: 22/255, green: 21/255, blue: 26/255)
                    .ignoresSafeArea()
                ScrollView {
                        HStackSnap(alignment: .leading(0)) {
                            ForEach(api.books) {anime in
                                ExtractedView(item: anime)
                            }
                        }
                        .frame(height: 500, alignment: .bottom)
                        .frame(maxWidth: .infinity)
                        
                    
                    
                    Text("Recently Released")
                        .foregroundColor(.white)
                        .bold()
                        .font(.title2)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 30) {
                            ForEach(0..<5) {_ in
                                RecentAnimeCard()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    
                }
                .ignoresSafeArea()
                .padding(.top, -60)
            }.onAppear() {
                api.loadData()
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

struct TrendingResults: Codable, Hashable {
    let currentPage: Int
    let hasNextPage: Bool
    let results: [IAnimeInfo]
}

struct IAnimeInfo: Codable, Hashable, Identifiable {
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

struct ITitle: Codable, Hashable {
    let romaji: String
    var english: String?
    let native: String
    var userPreferred: String?
}

struct ExtractedView: View {
    let item: IAnimeInfo
    
    var body: some View {
            ZStack(alignment: .leading) {
                AsyncImage(url: URL(string: "\(item.cover)")) { image in
                    image.resizable()
                        .blur(radius: 3)
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 500)
                        .frame(maxWidth: .infinity)
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
                    .frame(width: 390, height: 500)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    Text("\(item.duration) min / Episodes")
                        .fontWeight(.semibold)
                        .font(.caption)
                    Text("Episodes: \(item.totalEpisodes) - Status: \(item.status)")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                    Text("\(item.title.english!)")
                        .bold()
                        .font(.title)
                    Text(.init("\(item.description.replacingOccurrences(of: "<br><br>", with: "").replacingOccurrences(of: "<i>", with: "_").replacingOccurrences(of: "</i>", with: "_"))"))
                        .fontWeight(.medium)
                        .font(.footnote)
                        .lineLimit(10)
                        .frame(maxWidth: .infinity)
                        .padding(.top, -14)
                        .padding(.bottom, 8)
                        .padding(.leading, 0)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 35)
                            .fill(Color(#colorLiteral(red: 0.10196078568696976, green: 0.6823529601097107, blue: 0.9960784316062927, alpha: 1)))
                            .frame(width: 109, height: 43)
                        
                        Text("Info")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                    }
                    .padding(.leading, 20)
                    
                }
                .foregroundColor(.white)
                .frame(height: 500, alignment: .bottom)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
            }
            .snapAlignmentHelper(id: item.id)
            .aspectRatio(contentMode: .fill)
    }
}
