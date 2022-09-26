//
//  EpisodeCard.swift
//  Inus Stream
//
//  Created by Inumaki on 26.09.22.
//

import SwiftUI

struct EpisodeCard: View {
    let title: String
    let number: Int
    let thumbnail: String
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: thumbnail)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 74)
                    .cornerRadius(12)
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(.white)
                    .font(.caption)
                    .fontWeight(.heavy)
                    .lineLimit(2)
                Text("Episode \(number)")
                    .foregroundColor(Color(hex: "#ff999999"))
                    .font(.caption2)
                    .fontWeight(.heavy)
            }
        }
        .frame(maxWidth: 350, alignment: .leading)
    }
}

struct EpisodeCard_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeCard(title: "Title", number: 1, thumbnail: "https://artworks.thetvdb.com/banners/episodes/329822/6125438.jpg")
            .preferredColorScheme(.dark)
    }
}
