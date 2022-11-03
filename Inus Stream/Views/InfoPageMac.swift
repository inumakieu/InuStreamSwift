//
//  InfoPageMac.swift
//  Inus Stream
//
//  Created by Inumaki on 29.10.22.
//

import SwiftUI

struct InfoPageMac: View {
    let anilistId: String
    
    @StateObject var anilistApi = Anilist()
    @Environment(\.presentationMode) var presentation
    
    func getAiringTime(airingTime: Int) -> String {
        // convert seconds into days and hours
        let hours = airingTime / 60 / 60
        let days = hours / 24
        
        // return days if time is longer than one day
        if(days >= 1) {
            return String(days) + " days"
        } else {
            // return hours if time is less than one day
            return String(hours) + " hours"
        }
        
    }
    
    var body: some View {
        GeometryReader {proxy in
            ZStack {
                Color(hex: "#ff16151A")
                
                if anilistApi.infodata != nil {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ZStack(alignment: .top) {
                                AsyncImage(url: URL(string: anilistApi.infodata!.cover)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: proxy.size.height * 0.4, alignment: .top)
                                        .frame(maxWidth: proxy.size.width)
                                } placeholder: {
                                    ProgressView()
                                }
                                HStack {
                                    AsyncImage(url: URL(string: anilistApi.infodata!.image)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 290)
                                            .frame(maxWidth: 190)
                                            .cornerRadius(12)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    Spacer()
                                        .frame(maxWidth: 20)
                                    
                                    VStack(alignment: .leading) {
                                        Text("\(anilistApi.infodata!.title.english ?? anilistApi.infodata!.title.romaji)")
                                            .font(.largeTitle)
                                            .fontWeight(.heavy)
                                        Text("\(anilistApi.infodata!.title.native)")
                                            .bold()
                                            .font(.title2)
                                        
                                    }
                                }
                                .frame(width: proxy.size.width - 80, alignment: .leading)
                                .padding(.top, 252)
                                .padding(.horizontal, 40)
                            }
                            
                            HStack(alignment: .top, spacing: 30) {
                                ZStack {
                                    Color(hex: "#ff1E222C")
                                    
                                    VStack {
                                        Text("extra info")
                                            .foregroundColor(.white)
                                    }
                                }
                                .frame(width: 280, height: 700)
                                .cornerRadius(20)
                                
                                VStack(alignment: .leading) {
                                    ZStack {
                                        Color(hex: "#ff1E222C")
                                        
                                        VStack {
                                            Text(.init(anilistApi.infodata!.description.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "<br>", with: "\n").replacingOccurrences(of: "<i>", with: "_").replacingOccurrences(of: "</i>", with: "_")))
                                                .foregroundColor(.white)
                                                .fontWeight(.medium)
                                                .multilineTextAlignment(.center)
                                        }
                                        .padding(20)
                                    }
                                    .frame(maxWidth: proxy.size.width * 0.5)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .cornerRadius(20)
                                    
                                    HStack {
                                        ScrollView(.horizontal) {
                                            HStack(spacing: 12) {
                                                ForEach(0..<anilistApi.infodata!.genres.count) {genre in
                                                    ZStack {
                                                        Color(.black)
                                                        Text(anilistApi.infodata!.genres[genre])
                                                            .foregroundColor(.white)
                                                            .bold()
                                                            .font(.caption)
                                                            .bold()
                                                            .padding(.horizontal, 20)
                                                            .padding(.vertical, 12)
                                                    }
                                                    .frame(height: 32)
                                                    .cornerRadius(40)
                                                }
                                            }
                                        }
                                        .cornerRadius(40)
                                        
                                        if(anilistApi.infodata?.nextAiringEpisode != nil) {
                                            ZStack {
                                                Color(hex: "#ffEE4546")
                                                Text("Next Episode: \(getAiringTime(airingTime: anilistApi.infodata!.nextAiringEpisode!.timeUntilAiring))")
                                                    .bold()
                                                    .font(.caption)
                                                    .bold()
                                                    .multilineTextAlignment(.center)
                                            }
                                            .frame(height: 40)
                                            .frame(maxWidth: 100)
                                            .cornerRadius(12)
                                        }
                                    }
                                }
                                .frame(maxWidth: proxy.size.width * 0.5)
                                .padding(.horizontal, 40)
                            }
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
        }
        .onAppear() {
            anilistApi.getInfo(id: anilistId)
        }
        .navigationBarBackButtonHidden(true)
        .contentShape(Rectangle()) // Start of the gesture to dismiss the navigation
        .gesture(
            DragGesture(coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.width > .zero
                        && value.translation.height > -30
                        && value.translation.height < 30 {
                        presentation.wrappedValue.dismiss()
                    }
                }
        )
    }
}

struct InfoPageMac_Previews: PreviewProvider {
    static var previews: some View {
        InfoPageMac(anilistId: "98659")
    }
}
