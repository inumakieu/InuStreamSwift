//
//  TextTest.swift
//  Inus Stream
//
//  Created by Inumaki on 04.11.22.
//

import SwiftUI

struct TextTest: View {
    var body: some View {
        ZStack {
            Color(hex: "#ff333333")
            
            VStack {
                SimpleSubtitleDisplay(subtitle_text: "_I've never once thought of you as an ally._")
                
                Spacer()
                    .frame(maxHeight: 60)
                
                OutlinedSubtitleDisplay(subtitle_text: "_I've never once thought of you as an ally._")
                
                Spacer()
                    .frame(maxHeight: 60)
                
                Text("I've never once thought of you as an ally.")
                    .foregroundColor(.white)
                    .font(.custom("TrebuchetMS", size: 22))
                    .italic()
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                    .shadow(color: .black, radius: 2, x: 0, y: 0)
                    .multilineTextAlignment(.center)
            
                Spacer()
                    .frame(maxHeight: 60)
                
                BackgroundSubtitleDisplay(subtitle_text: "_I've never once thought of you as an ally._")
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct SimpleSubtitleDisplay: View {
    var subtitle_text: String
    
    var body: some View {
        Text(.init(subtitle_text))
            .foregroundColor(.white)
            .font(.custom("TrebuchetMS", size: 22))
            .shadow(color: .black, radius: 2, x: 2, y: 2)
            .multilineTextAlignment(.center)
    }
}

struct BackgroundSubtitleDisplay: View {
    var subtitle_text: String
    
    var body: some View {
        ZStack {
            Color(.black.withAlphaComponent(0.6))
            
            Text(.init(subtitle_text))
                .foregroundColor(.white)
                .font(.custom("TrebuchetMS", size: 22))
                .padding(.vertical, 2)
                .padding(.horizontal, 8)
        }
        .fixedSize()
        .cornerRadius(4)
    }
}

struct OutlinedSubtitleDisplay: View {
    var subtitle_text: String
    
    var body: some View {
        ZStack {
            
             Text(.init(subtitle_text))
                 .foregroundColor(.black)
                 .font(.custom("TrebuchetMS", size: 22))
             .shadow(color: .black, radius: 0.2, x: 1, y: 1)
             .shadow(color: .black, radius: 0.2, x: 1, y: 0)
             .shadow(color: .black, radius: 0.2, x: 1, y: -1)
             .shadow(color: .black, radius: 0.2, x: 0, y: -1)
             .shadow(color: .black, radius: 0.2, x: 0, y: 0)
             .shadow(color: .black, radius: 0.2, x: 0, y: 1)
             .shadow(color: .black, radius: 0.2, x: -1, y: -1)
             .shadow(color: .black, radius: 0.2, x: -1, y: 0)
             .shadow(color: .black, radius: 0.2, x: -1, y: 1)
                 .multilineTextAlignment(.center)
                 .offset(x: 2, y: 2)
             
            
            Text(.init(subtitle_text))
                .foregroundColor(.white)
                .font(.custom("TrebuchetMS", size: 22))
                .shadow(color: .black, radius: 0.2, x: 1, y: 1)
                .shadow(color: .black, radius: 0.2, x: 1, y: 0)
                .shadow(color: .black, radius: 0.2, x: 1, y: -1)
                .shadow(color: .black, radius: 0.2, x: 0, y: -1)
                .shadow(color: .black, radius: 0.2, x: 0, y: 0)
                .shadow(color: .black, radius: 0.2, x: 0, y: 1)
                .shadow(color: .black, radius: 0.2, x: -1, y: -1)
                .shadow(color: .black, radius: 0.2, x: -1, y: 0)
                .shadow(color: .black, radius: 0.2, x: -1, y: 1)
                .multilineTextAlignment(.center)
            
            
        }
    }
}

struct TextTest_Previews: PreviewProvider {
    static var previews: some View {
        TextTest()
    }
}
