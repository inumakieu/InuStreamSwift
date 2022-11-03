//
//  EpisodeView.swift
//  Inus Stream
//
//  Created by Inumaki on 25.10.22.
//

import SwiftUI
import SwiftUIFontIcon

struct EpisodeView: View {
    let infoApi: InfoApi
    let mangaApi: MangaApi
    let id: String
    @State var moveToManga: Bool = false
    @State var isManga: Bool = false
    @State var mangaData: MangaInfo? = nil
    @State var firstEpisodeNumber: Int = 1
    @State var lastEpisodeNumber: Int = 24
    
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
        VStack {
            HStack {
                ZStack {
                    Color(.black)
                    
                    FontIcon.button(.awesome5Solid(code: .bookmark), action: {
                        
                    }, fontsize: 22)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 13)
                }
                .fixedSize()
                .cornerRadius(40)
                
                Spacer()
                
                ZStack {
                    Color(hex: "#ffEE4546")
                    
                    Text("\(isManga ? "Read CP" : "Play EP") 1")
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                }
                .fixedSize()
                .cornerRadius(8)
                
                Spacer()
                
                ZStack {
                        Color(.black)
                        
                        FontIcon.button(.awesome5Solid(code: .book_open), action: {
                            //moveToManga = true
                            // fetch chapters
                            Task {
                                mangaData = await mangaApi.getInfo(id: id)
                                print(mangaData)
                                isManga = !isManga
                            }
                        }, fontsize: 22)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 9)
                    }
                    .fixedSize()
                    .cornerRadius(40)
                
                
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 40)
            
            ZStack {
                Color(hex: "#ff1E222C")
                Text(.init(infoApi.infodata!.description.replacingOccurrences(of: "<br>", with: "").replacingOccurrences(of: "<i>", with: "_").replacingOccurrences(of: "</i>", with: "_")))
                    .foregroundColor(.white)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.all, 20)
            }
            .frame(maxWidth: 350)
            .fixedSize(horizontal: false, vertical: true)
            .cornerRadius(20)
            .padding(.all, 20)
            
            HStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(0..<infoApi.infodata!.genres.count) {genre in
                            ZStack {
                                Color(.black)
                                Text(infoApi.infodata!.genres[genre])
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
                
                if(infoApi.infodata?.nextAiringEpisode != nil) {
                    ZStack {
                        Color(hex: "#ffEE4546")
                        Text("Next Episode: \(getAiringTime(airingTime: infoApi.infodata!.nextAiringEpisode!.timeUntilAiring))")
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
            .padding(.horizontal, 20)
            .frame(maxWidth: 390)
            
            HStack {
                Text("\(mangaData != nil ? "Chapters" : "Episodes")")
                    .foregroundColor(.white)
                    .font(.title)
                    .bold()
                    .frame(maxWidth: 340, alignment: .leading)
                    .padding(.top, 10)
                
                Spacer()
                
                if(infoApi.infodata!.episodes!.count > 24) {
                    Menu {
                        ForEach(0..<((infoApi.infodata!.episodes!.count / 24) + 1)) { index in
                            Button {
                                firstEpisodeNumber = 24 * index + 1
                                lastEpisodeNumber = 24 + (24 * index) > infoApi.infodata!.episodes!.count ? infoApi.infodata!.episodes!.count : 24 + (24 * index)
                            } label: {
                                Text("\(24 * index + 1) - \(24 + (24 * index) > infoApi.infodata!.episodes!.count ? infoApi.infodata!.episodes!.count : 24 + (24 * index))")
                                Image(systemName: "arrow.down.right.circle")
                            }
                        }
                    } label: {
                        ZStack {
                            Color(.black)
                            
                            HStack {
                                Text("\(firstEpisodeNumber) - \(lastEpisodeNumber)")
                                    .bold()
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.down")
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                        }
                        .fixedSize()
                        .cornerRadius(40)
                    }
                }
            }
            .padding(.horizontal, 20)
            
            if(!isManga) {
                ScrollView {
                    VStack(spacing: 18) {
                        ForEach((firstEpisodeNumber - 1)..<(infoApi.infodata!.episodes!.count < lastEpisodeNumber ? infoApi.infodata!.episodes!.count : lastEpisodeNumber), id: \.self) {index in
                            EpisodeCard(animeData: infoApi.infodata!,title: infoApi.infodata!.episodes![index].title ?? infoApi.infodata!.title.romaji, number: infoApi.infodata!.episodes![index].number ?? 0, thumbnail: infoApi.infodata!.episodes![index].image, isFiller: infoApi.infodata!.episodes![index].isFiller
                            )
                            .contextMenu {
                                VStack {
                                    Button(action: {
                                        // set this episode as watched
                                        
                                    }) {
                                        HStack {
                                            Text("Mark as watched")
                                            
                                            Image(systemName: "eye.fill")
                                        }
                                    }
                                    Button(action: {}) {
                                        HStack {
                                            Text("Set to current Episode")
                                            
                                            Image(systemName: "eye.fill")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: 350, alignment: .leading)
                }
                .frame(maxHeight: .infinity)
                .padding(.bottom, 130)
            } else {
                ScrollView {
                    VStack(spacing: 18) {
                        ForEach(0..<mangaData!.chapters!.count) {index in
                            ChapterView(mangaChapter: mangaData!.chapters![index], animeImage: infoApi.infodata!.image, chapterNumber: index, englishTitle: infoApi.infodata!.title.english ?? infoApi.infodata!.title.romaji, mangaData: mangaData!)
                        }
                    }
                    .frame(maxWidth: 350, alignment: .leading)
                }
                .frame(maxHeight: 500)
                .padding(.bottom, 130)
            }
            
        }
        .frame(height: 1300, alignment: .top)
        .frame(maxHeight: 1300, alignment: .top)
    }
}
