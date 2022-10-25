//
//  SearchPage.swift
//  Inus Stream
//
//  Created by Inumaki on 28.09.22.
//

import SwiftUI

struct SearchPage: View {
    @State private var animeName: String = ""
    @StateObject var searchApi = SearchApi()
    
    var body: some View {
            ZStack(alignment: .top) {
                Color(hex: "#ff16151A")
                    .ignoresSafeArea()
                VStack {
                    
                    Text("Search")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)
                        .padding(.top, 30)
                        
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color(hex: "#ff1F212B"))
                        
                        TextField(
                            "Search for an Anime...",
                            text: $animeName
                        )
                        .foregroundColor(.white)
                        .onChange(of: animeName){ newValue in
                            searchApi.searchAnime(animeName: newValue.lowercased().replacingOccurrences(of: " ", with: "-"))
                        }
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .padding(.horizontal, 12)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                    
                    ScrollView(.vertical) {
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(0..<searchApi.searchdata.count, id: \.self) { index in
                                NavigationLink(destination: InfoPage(anilistId: searchApi.searchdata[index].id)) {
                                    HStack(spacing: 12) {
                                        AsyncImage(url: URL(string: searchApi.searchdata[index].image)) { image in
                                            image.resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 100, height: 132)
                                                .cornerRadius(12)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        
                                        ZStack(alignment: .top) {
                                            Color(.black)
                                            
                                            if(searchApi.searchdata[index].cover != nil) {
                                                AsyncImage(url: URL(string: searchApi.searchdata[index].cover ?? "")) { image in
                                                    image.resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 192,height: 90)
                                                        .frame(maxWidth: .infinity)
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                            } else {
                                                AsyncImage(url: URL(string: searchApi.searchdata[index].image)) { image in
                                                    image.resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(height: 90)
                                                        .frame(maxWidth: .infinity)
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                            }
                                            
                                            
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(LinearGradient(
                                                        gradient: Gradient(stops: [
                                                    .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.46000000834465027)), location: 0),
                                                    .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), location: 0.6)]),
                                                        startPoint: UnitPoint(x: 0, y: 0),
                                                        endPoint: UnitPoint(x: 0, y: 1)))
                                            .frame(height: 132)
                                            .frame(maxWidth: .infinity)
                                            
                                            VStack {
                                                Spacer()
                                                Text(searchApi.searchdata[index].title.english ?? searchApi.searchdata[index].title.romaji)
                                                    .bold()
                                                    .font(.system(size: 12, weight: .heavy))
                                                    .foregroundColor(.white)
                                                    .lineLimit(1)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                Text(.init((searchApi.searchdata[index].description ?? "").replacingOccurrences(of: "<br>", with: "").replacingOccurrences(of: "<i>", with: "_").replacingOccurrences(of: "</i>", with: "_")))
                                                    .font(.system(size: 7))
                                                    .foregroundColor(.white)
                                                    .lineLimit(4)
                                                    .multilineTextAlignment(.leading)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                HStack{
                                                    ZStack {
                                                        Color(hex: "#ff1F212B")
                                                        
                                                        Text(searchApi.searchdata[index].status)
                                                            .font(.system(size: 5))
                                                    }
                                                    .frame(width: 50, height: 20)
                                                    .cornerRadius(4)
                                                }
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.all, 8)
                                        }
                                        .frame(height: 132)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .cornerRadius(12)
                                        
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                    }
                    
                }
            }
        
    }
}

struct SearchPage_Previews: PreviewProvider {
    static var previews: some View {
        SearchPage()
    }
}

class SearchApi : ObservableObject{
    @Published var searchdata = [IAnimeInfo]()
    
    func searchAnime(animeName: String) {
        guard let url = URL(string: "https://api.consumet.org/meta/anilist/\(animeName)") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let books = try! JSONDecoder().decode(TrendingResults.self, from: data!)
            print(books)
            DispatchQueue.main.async {
                self.searchdata = books.results
            }
        }.resume()
    }
}
