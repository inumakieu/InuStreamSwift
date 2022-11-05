//
//  TextTest.swift
//  Inus Stream
//
//  Created by Inumaki on 04.11.22.
//

import SwiftUI

struct TextTest: View {
    var body: some View {
        VStack {
            Text("I’ve never once thought of you as an ally.")
                .foregroundColor(.white)
                .font(.custom("TrebuchetMS", size: 22))
                .italic()
                .shadow(color: .black, radius: 2, x: 2, y: 2)
                .multilineTextAlignment(.center)
            
            Spacer()
                .frame(maxHeight: 60)
            
            SubtitleTextDisplay(subtitle_text: "I've never once thought of you as an ally.")
        }
    }
}

struct SubtitleTextDisplay: View {
    var subtitle_text: String
    
    var body: some View {
        ZStack {
            
             Text(.init(subtitle_text))
                 .foregroundColor(.black)
                 .font(.custom("TrebuchetMS", size: 22))
                 .italic()
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
                .italic()
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
