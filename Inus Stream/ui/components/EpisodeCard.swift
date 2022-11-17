//
//  EpisodeCard.swift
//  Inus Stream
//
//  Created by Inumaki on 26.09.22.
//

import SwiftUI

struct EpisodeCard: View {
    let animeData: InfoData?
    let title: String
    let number: Int
    let thumbnail: String
    let isFiller: Bool?
    @Environment(\.managedObjectContext) var storage
    @FetchRequest(sortDescriptors: []) var animeStorageData: FetchedResults<AnimeStorageData>
    
    var body: some View {
        NavigationLink(destination: WatchPage(aniData: animeData, episodeIndex: number - 1, anilistId: nil)) {
            HStack {
                ZStack(alignment: .bottomTrailing) {
                    AsyncImage(url: URL(string: thumbnail)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 74)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    
                    
                    if(isFiller != nil && isFiller! == true) {
                        ZStack {
                            Color(hex: "#ff738CA5")
                            
                            Text("Filler")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(width: 44, height: 16)
                        .cornerRadius(8)
                        .padding(6)
                    }
                    
                    let index = animeStorageData.firstIndex(where: {($0.id!) == animeData?.id})
                    
                    if(index != nil && (animeStorageData[index!].watched != nil && animeStorageData[index!].watched!.contains(number))) {
                        VStack(alignment: .leading) {
                            ZStack {
                                Color(.black)
                                
                                Text("Watched")
                                    .font(.system(size: 8, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 70, height: 20)
                            .cornerRadius(12, corners: [.bottomRight])
                            
                            Spacer()
                        }
                        .frame(width: 120, height: 74, alignment: .leading)
                    }
                    
                }
                .frame(width: 120, height: 74)
                .cornerRadius(12)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundColor(.white)
                        .font(.caption)
                        .fontWeight(.heavy)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    Spacer()
                        .frame(maxHeight: 8)
                    Text("Episode \(number)")
                        .foregroundColor(Color(hex: "#ff999999"))
                        .font(.caption2)
                        .fontWeight(.heavy)
                }
            }
            .frame(maxWidth: 350, alignment: .leading)
            
        }.simultaneousGesture(TapGesture().onEnded{
            
        })
        
    }
}

struct EpisodeCard_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeCard(animeData: nil, title: "Title", number: 1, thumbnail: "https://artworks.thetvdb.com/banners/episodes/329822/6125438.jpg", isFiller: true)
            .preferredColorScheme(.dark)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
