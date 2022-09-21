//
//  ContentView.swift
//  Inus Stream
//
//  Created by L Lawliet on 19.09.22.
//

import SwiftUI

struct RecentAnimeCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/b98659-sH5z5RfMuyMr.png")) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 130, height: 200)
                    .cornerRadius(12)
            } placeholder: {
                ProgressView()
            }
            
            Text("Classroom of the Elite")
                .font(.callout)
                .foregroundColor(Color.gray)
                .bold()
                .lineLimit(1)
                .frame(width: 130)
            
            Text("Episode 1")
                .font(.footnote)
                .foregroundColor(Color.gray)
                .bold()
                .padding(.leading, 3.0)
        }
    }
}

struct RecentAnimeCard_Previews: PreviewProvider {
    static var previews: some View {
        RecentAnimeCard()
            .preferredColorScheme(.dark)
    }
}

