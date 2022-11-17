//
//  HomePageMac.swift
//  Inus Stream
//
//  Created by Inumaki on 29.10.22.
//

import SwiftUI
import SwiftUIFontIcon
import Shimmer

struct HomePageMac: View {
    
    @StateObject var anilistApi = Anilist()
    
    @State private var autoSkipIntro = false
    @State private var autoSkipOutro = false
    @State private var autoPlayNext = false
    @State private var infoButtonHover = false
    
    
    var body: some View {
        return NavigationView {
            GeometryReader {proxy in
               ZStack {
                   Color(hex: "#ff16151A")
                   
                   HStack {
                       if proxy.size.width > 1000 {
                           VStack {
                               AsyncImage(url: URL(string: "https://preview.redd.it/12spjh08sfg31.jpg?auto=webp&s=17b3acfcf4a1af63b940371ac3af02379e24b99a")) { image in
                                   image
                                       .resizable()
                                       .aspectRatio(contentMode: .fill)
                                       .frame(width: 100, height: 100)
                                       .cornerRadius(50)
                               } placeholder: {
                                   ProgressView()
                               }
                               
                               HStack {
                                   Text("Inumaki")
                                       .foregroundColor(.white)
                                       .bold()
                                       .font(.title)
                                   
                                   
                                   FontIcon.button(.awesome5Solid(code: .crown), action: {
                                       
                                   }, fontsize: 18)
                                   .foregroundColor(Color(hex: "#ffFFDF00"))
                               }
                               
                               Text("General Settings")
                                   .bold()
                                   .foregroundColor(.white)
                                   .font(.title3)
                                   .frame(maxWidth: .infinity, alignment: .leading)
                                   .padding(.horizontal, 20)
                                   .padding(.top, 30)
                               
                               HStack {
                                   Text("Provider")
                                       .foregroundColor(.white)
                                       .bold()
                                       .font(.subheadline)
                                   
                                   Spacer()
                                   
                                   Menu {
                                       Button {
                                           print("pressed")
                                       } label: {
                                           Text("Zoro")
                                       }
                                       Button {
                                           print("pressed")
                                       } label: {
                                           Text("Gogoanime")
                                       }
                                       Button {
                                           print("pressed")
                                       } label: {
                                           Text("9Anime")
                                       }
                                       Button {
                                           print("pressed")
                                       } label: {
                                           Text("Crunchyroll")
                                       }
                                   } label: {
                                       ZStack {
                                           Color(hex: "#ff1E222C")
                                               
                                           Text("Zoro")
                                                   .bold()
                                                   .foregroundColor(.white)
                                                   .frame(width: 120, height: 40)
                                       }
                                       .fixedSize()
                                       .cornerRadius(12)
                                   }
                               }
                               .frame(maxWidth: .infinity)
                               .padding(.horizontal, 20)
                               
                               
                               
                               VStack {
                                   Text("Video Settings")
                                       .bold()
                                       .foregroundColor(.white)
                                       .font(.title3)
                                       .frame(maxWidth: .infinity, alignment: .leading)
                                       .padding(.horizontal, 20)
                                       .padding(.top, 30)
                                   
                                   HStack {
                                       Text("Autoskip Intro")
                                           .foregroundColor(.white)
                                           .bold()
                                           .font(.subheadline)
                                       
                                       Spacer()
                                       
                                       Toggle("", isOn: $autoSkipIntro)
                                   }
                                   .frame(maxWidth: .infinity)
                                   .padding(.horizontal, 20)
                                   
                                   HStack {
                                       Text("Autoskip Outro")
                                           .foregroundColor(.white)
                                           .bold()
                                           .font(.subheadline)
                                       
                                       Spacer()
                                       
                                       Toggle("", isOn: $autoSkipOutro)
                                   }
                                   .frame(maxWidth: .infinity)
                                   .padding(.horizontal, 20)
                                   
                                   HStack {
                                       Text("Autoplay Next Episode")
                                           .foregroundColor(.white)
                                           .bold()
                                           .font(.subheadline)
                                       
                                       Spacer()
                                       
                                       Toggle("", isOn: $autoPlayNext)
                                   }
                                   .frame(maxWidth: .infinity)
                                   .padding(.horizontal, 20)
                               }
                               
                               
                               
                               HStack {
                                   VStack(alignment: .leading) {
                                       Text("Subtitle Language")
                                           .foregroundColor(.white)
                                           .bold()
                                           .font(.subheadline)
                                       
                                       Text("Falls back to English if unavailable")
                                           .foregroundColor(Color(hex: "#ff999999"))
                                           .font(.caption2)
                                   }
                                   
                                   Spacer()
                                   
                                   Menu {
                                       Button {
                                           print("pressed")
                                       } label: {
                                           Text("English")
                                       }
                                       Button {
                                           print("pressed")
                                       } label: {
                                           Text("German")
                                       }
                                       Button {
                                           print("pressed")
                                       } label: {
                                           Text("Italian")
                                       }
                                       Button {
                                           print("pressed")
                                       } label: {
                                           Text("Japanese")
                                       }
                                   } label: {
                                       ZStack {
                                           Color(hex: "#ff1E222C")
                                               
                                           Text("English")
                                                   .bold()
                                                   .foregroundColor(.white)
                                                   .frame(width: 120, height: 40)
                                       }
                                       .fixedSize()
                                       .cornerRadius(12)
                                   }
                               }
                               .frame(maxWidth: .infinity)
                               .padding(.horizontal, 20)
                               
                               Spacer()
                               
                               
                               VStack {
                                   Text("Build Number: 0.0.1-alpha")
                                       .foregroundColor(Color(hex: "#ff999999"))
                                   Text("Build Type: Mac Catalyst")
                                       .foregroundColor(Color(hex: "#ff999999"))
                                   Text("Creator: Inumaki")
                                       .foregroundColor(Color(hex: "#ff999999"))
                               }
                               .fixedSize()
                           }
                           .frame(width: 350, height: proxy.size.height - 80)
                           .padding(.top, 70)
                       }
                       
                       ScrollView {
                           VStack(alignment: .leading) {
                               if anilistApi.trendingData.count > 0 {
                                   TabView() {
                                           ForEach(0..<anilistApi.trendingData.count) {index in
                                               ZStack {
                                                   AsyncImage(url: URL(string: anilistApi.trendingData[index].cover!)) { image in
                                                       image
                                                           .resizable()
                                                           .aspectRatio(contentMode: .fill)
                                                           .frame(height: proxy.size.height * 0.7)
                                                           .frame(maxWidth: proxy.size.width - 350)
                                                   } placeholder: {
                                                       ProgressView()
                                                   }
                                                   
                                                   Rectangle()
                                                       .fill(LinearGradient(
                                                        gradient: Gradient(stops: [
                                                            .init(color: Color(hex: "#0016151A"), location: 0),
                                                            .init(color: Color(hex: "#cf16151A"), location: 0.5),
                                                            .init(color: Color(hex: "#ff16151A"), location: 1)]),
                                                        startPoint: UnitPoint(x: 0, y: 0),
                                                        endPoint: UnitPoint(x: 0, y: 1)))
                                                       .frame(height: proxy.size.height * 0.7)
                                                       .frame(maxWidth: .infinity)
                                                   
                                                   VStack(alignment: .leading) {
                                                       Text("24 min / Episode")
                                                           .foregroundColor(.white)
                                                       
                                                       HStack {
                                                           Text("Episodes: ")
                                                               .foregroundColor(.white)
                                                               .bold()
                                                           Text("12")
                                                               .foregroundColor(.red)
                                                               .bold()
                                                           Text(" - Status: ")
                                                               .foregroundColor(.white)
                                                               .bold()
                                                           Text("COMPLETED")
                                                               .foregroundColor(.red)
                                                               .bold()
                                                       }
                                                       .font(.title2)
                                                       
                                                       
                                                       Text("\(anilistApi.trendingData[index].title.english ?? anilistApi.trendingData[index].title.romaji)")
                                                           .foregroundColor(.white)
                                                           .font(.system(size: 32, weight: .heavy))
                                                       
                                                       Text("Koudo Ikusei Senior High School is a leading school with state-of-the-art facilities. The students there have the freedom to wear any hairstyle and bring any personal effects they desire. Koudo Ikusei is like a utopia, but the truth is that only the most superior students receive favorable treatment.\n\nKiyotaka Ayanokouji is a student of D-class, which is where the school dumps its \"inferior\" students in order to ridicule them. For a certain reason, Kiyotaka was careless on his entrance examination, and was put in D-class. After meeting Suzune Horikita and Kikyou Kushida, two other students in his class, Kiyotaka's situation begins to change. \n(Source: Anime News Network, edited)")
                                                           .foregroundColor(.white)
                                                           .fontWeight(.medium)
                                                           .font(.subheadline)
                                                           .multilineTextAlignment(.leading)
                                                           .lineLimit(20)
                                                           .frame(maxWidth: 700)
                                                       
                                                       NavigationLink(destination: InfoPageMac(anilistId: anilistApi.trendingData[index].id)) {
                                                           ZStack {
                                                               Color(hex: "#ff1AAEFE")
                                                               
                                                               HStack {
                                                                   FontIcon.button(.awesome5Solid(code: .info_circle), action: {
                                                                       
                                                                   }, fontsize: 22)
                                                                   .foregroundColor(.white)
                                                                   
                                                                   Text("INFO")
                                                                       .foregroundColor(.white)
                                                                       .bold()
                                                               }
                                                               .padding(.vertical, 12)
                                                               .padding(.horizontal, 20)
                                                           }
                                                           .fixedSize()
                                                           .cornerRadius(40)
                                                           .onHover {over in
                                                               print(over)
                                                               infoButtonHover.toggle()
                                                           }
                                                           .shadow(color: infoButtonHover ? Color(hex: "#ff1AAEFE") : Color(hex: "#001AAEFE"),radius: 12, x: 0, y: 0)
                                                           .animation(.spring(response: 0.3), value: infoButtonHover)
                                                       }
                                                       
                                                   }
                                                   .frame(width: proxy.size.width - 100, alignment: .leading)
                                               }
                                           }
                                       
                                   }.tabViewStyle(.page(indexDisplayMode: .never))
                                       .indexViewStyle(.page(backgroundDisplayMode: .always))
                                   .frame(width: proxy.size.width, height: proxy.size.height * 0.7)
                                   .frame(maxWidth: proxy.size.width)
                               }
                               
                               if anilistApi.recentsData != [] {
                                   VStack(alignment: .leading) {
                                       Text("Recently Added")
                                           .bold()
                                           .foregroundColor(.white)
                                           .font(.largeTitle)
                                       
                                       
                                       ScrollView(.horizontal) {
                                           HStack(spacing: 20) {
                                               ForEach(0..<anilistApi.recentsData.count) {index in
                                                   RecentAnimeCard(anime: anilistApi.recentsData[index])
                                               }
                                           }
                                       }
                                       .frame(maxWidth: proxy.size.width - 420)
                                       
                                       
                                   }
                                   .padding(.horizontal, 60)
                                   .padding(.top, 30)
                               }
                               
                               Spacer()
                                   .frame(height: 100)
                                   .frame(maxHeight: 100)
                           }
                       }
                   }
               }
               .edgesIgnoringSafeArea(.all)
           }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            print("working?")
            anilistApi.getTrending()
            anilistApi.getRecents()
            
        }
    }
}

struct HomePageMac_Previews: PreviewProvider {
    static var previews: some View {
        HomePageMac()
    }
}
