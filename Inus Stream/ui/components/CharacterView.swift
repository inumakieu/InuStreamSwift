//
//  CharacterView.swift
//  Inus Stream
//
//  Created by Inumaki on 25.10.22.
//

import SwiftUI

struct CharacterView: View {
    let infoApi: InfoApi
    
    func onEndOfList() {
        print("bottom")
    }
    
    func onTopOfList() {
        print("top")
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading,spacing: 20) {
                    ForEach(0..<infoApi.infodata!.characters.count) {charIndex in
                        ZStack {
                            Color(hex: "#ff1E222C")
                            
                            HStack {
                                AsyncImage(url: URL(string: infoApi.infodata!.characters[charIndex].image)) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 90)
                                        .cornerRadius(12)
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                ZStack(alignment: .bottom) {
                                    VStack(alignment: .leading) {
                                        Text("\(infoApi.infodata!.characters[charIndex].name.userPreferred)")
                                            .foregroundColor(.white)
                                            .bold()
                                        Text(infoApi.infodata!.characters[charIndex].name.native ?? "")
                                            .foregroundColor(.white)
                                            .font(.caption)
                                            .bold()
                                    }
                                    .frame(height: 90, alignment: .center)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    if(infoApi.infodata!.characters[charIndex].voiceActors != nil && infoApi.infodata!.characters[charIndex].voiceActors!.count > 0) {
                                        Text(infoApi.infodata!.characters[charIndex].voiceActors?[0].name.userPreferred ?? "")
                                            .foregroundColor(Color(hex: "#ff999999"))
                                            .font(.caption)
                                            .bold()
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                            .padding(.bottom, 8)
                                            .padding(.trailing, 8)
                                    }
                                    
                                }
                                .frame(height: 90, alignment: .bottom)
                                .frame(maxWidth: .infinity)
                                AsyncImage(url: URL(string: infoApi.infodata!.characters[charIndex].voiceActors!.count > 0 ? infoApi.infodata!.characters[charIndex].voiceActors![0].image : "")) { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 60, height: 90)
                                            .cornerRadius(12)
                                    } placeholder: {
                                        ProgressView()
                                    }
                            }
                            .frame(width: 330)
                        }
                        .cornerRadius(12)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 700, alignment: .top)
            .frame(maxHeight: 700, alignment: .top)
            
            Spacer()
        }
        .frame(height: 1300, alignment: .top)
        .frame(maxHeight: 1300, alignment: .top)
        
    }
}
