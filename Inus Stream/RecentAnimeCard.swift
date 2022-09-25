//
//  ContentView.swift
//  Inus Stream
//
//  Created by L Lawliet on 19.09.22.
//

import SwiftUI

struct RecentAnimeCard: View {
    let anime: IAnimeRecent
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: anime.image)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 210)
                    .cornerRadius(20)
            } placeholder: {
                ProgressView()
            }
            
            Text(anime.title.english ?? anime.title.romaji)
                .font(.callout)
                .foregroundColor(Color.gray)
                .bold()
                .lineLimit(1)
                .frame(width: 140, alignment: .leading)
                .padding(.horizontal, 3.0)
            
            Text("Episode \(anime.episodeNumber)")
                .font(.footnote)
                .foregroundColor(Color.gray)
                .bold()
                .padding(.leading, 3.0)
        }
    }
}

struct RecentAnimeCard_Previews: PreviewProvider {
    static var previews: some View {
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
            .preferredColorScheme(.dark)
    }
}

