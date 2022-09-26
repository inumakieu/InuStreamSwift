//
//  ContinueWatching.swift
//  Inus Stream
//
//  Created by Inumaki on 25.09.22.
//

import SwiftUI

struct ContinueWatching: View {
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                AsyncImage(url: URL(string: "https://artworks.thetvdb.com/banners/episodes/329822/6125438.jpg")) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 220, height: 130)
                        .cornerRadius(20)
                } placeholder: {
                    ProgressView()
                }
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(
                            gradient: Gradient(stops: [
                        .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)), location: 0),
                        .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6309255957603455)), location: 0.5),
                        .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), location: 0.8),
                        .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), location: 1)]),
                            startPoint: UnitPoint(x: 0, y: 0),
                            endPoint: UnitPoint(x: 0, y: 1)))
                    .frame(width: 220, height: 130)
                
                VStack {
                    Image(systemName: "play.fill")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        
                        Spacer()
                        
                        Text("18:44 / 24:01")
                            .foregroundColor(Color(hex: "#ffACACAC"))
                            .font(.custom("", size: 10))
                            .bold()
                    }
                    .padding(.horizontal, 20)
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .frame(maxWidth: .infinity)
                            .frame(height: 6)
                            .foregroundColor(Color(hex: "#ffffffff"))
                        RoundedRectangle(cornerRadius: 3)
                            .frame(width: 60)
                            .frame(height: 6)
                            .foregroundColor(Color(hex: "#ffB93434"))
                    }
                    .padding(.horizontal, 14)
                    .padding(.bottom, 12)
                }
                .frame(width: 220, height: 130)
            }
            
            
            
            Text("Classroom of the Elite")
                .font(.callout)
                .foregroundColor(Color.gray)
                .bold()
                .lineLimit(1)
                .frame(width: 220, alignment: .leading)
                .padding(.leading, 14.0)
                .padding(.top, 0)
        }
    }
}

struct ContinueWatching_Previews: PreviewProvider {
    static var previews: some View {
        ContinueWatching()
    }
}
