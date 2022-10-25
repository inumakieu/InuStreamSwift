//
//  ContinueWatching.swift
//  Inus Stream
//
//  Created by Inumaki on 25.09.22.
//

import SwiftUI

struct ContinueWatching: View {
    let image: String
    let progress: Double
    let title: String
    let currentTime: Double
    let duration: Double
    let number: Int16
    
    func secondsToMinutesSeconds(seconds: Int) -> String {
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        
        let minuteString = (minutes < 10 ? "0" : "") +  "\(minutes)"
        let secondsString = (seconds < 10 ? "0" : "") +  "\(seconds)"
        
        return minuteString + ":" + secondsString
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                AsyncImage(url: URL(string: image ?? "https://artworks.thetvdb.com/banners/episodes/329822/6125438.jpg")) { image in
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
                    Text("\(number)")
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 14)
                        .padding(.top, 10)
                    
                    Spacer()
                    
                    HStack {
                        
                        Spacer()
                        
                        Text("\(secondsToMinutesSeconds(seconds: Int(currentTime.rounded()))) / \(secondsToMinutesSeconds(seconds: Int(duration.rounded())))")
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
                            .frame(width: (220 - 28) * (currentTime / duration ?? 0.0))
                            .frame(height: 6)
                            .foregroundColor(Color(hex: "#ffB93434"))
                    }
                    .padding(.horizontal, 14)
                    .padding(.bottom, 12)
                }
                .frame(width: 220, height: 130)
            }
            
            
            
            Text("\(title)")
                .font(.callout)
                .foregroundColor(Color.gray)
                .bold()
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 220, alignment: .center)
                .padding(.top, 0)
        }
    }
}

struct ContinueWatching_Previews: PreviewProvider {
    static var previews: some View {
        ContinueWatching(image: "", progress: 0.0, title: "", currentTime: 0.0, duration: 0.0, number: 0)
    }
}
