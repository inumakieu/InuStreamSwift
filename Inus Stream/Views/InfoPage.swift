//
//  InfoPage.swift
//  Inus Stream
//
//  Created by Inumaki on 26.09.22.
//

import SwiftUI
import Shimmer
import SwiftUIFontIcon

struct InfoPage: View {
    let anilistId: String
    @StateObject var infoApi = InfoApi()
    @StateObject var mangaApi = MangaApi()
    @Environment(\.presentationMode) var presentation
    @State private var selection = 2
    @State private var paddingOffset: CGFloat = 80
    @State private var paddingStyle: Edge.Set = .trailing
    @State private var pillWidth: CGFloat = 78
    
    init(anilistId: String) {
        self.anilistId = anilistId
    }
    
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
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        if #available(iOS 16.0, *) {
            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
        } else {
            // Fallback on earlier versions
        }
        return ZStack(alignment: .top) {
            Color(hex: "#ff16151A")
                .ignoresSafeArea()
            
            if(infoApi.infodata != nil) {
                ScrollView(showsIndicators: false) {
                    
                    ZStack(alignment: .bottom) {
                        AsyncImage(url: URL(string: infoApi.infodata!.cover)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 440)
                                .frame(maxWidth: .infinity, maxHeight: 440)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Rectangle()
                            .fill(LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color(hex: "#0016151A"), location: 0),
                                    .init(color: Color(hex: "#9016151A"), location: 0.5),
                                    .init(color: Color(hex: "#ff16151A"), location: 1)
                                ]),
                                startPoint: UnitPoint(x: 0.0, y: 0),
                                endPoint: UnitPoint(x: 0.0, y: 1)))
                            .frame(height: 440)
                            .frame(maxWidth: .infinity, maxHeight: 440)
                            .ignoresSafeArea()
                        
                        AsyncImage(url: URL(string: infoApi.infodata!.image)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 176, height: 270)
                                .cornerRadius(20)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    .frame(height: 440)
                    .frame(maxWidth: .infinity, maxHeight: 440, alignment: .top)
                    
                    Text(infoApi.infodata!.title.english ?? infoApi.infodata!.title.romaji)
                        .bold()
                        .font(.title)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 350)
                        .padding(.top, 14)
                    Text(infoApi.infodata!.title.native)
                        .bold()
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 350)
                        .padding(.bottom, 0)
                    
                    TabView(selection: $selection) {
                        ExtraInfoView(infoApi: infoApi)
                            .fixedSize()
                            .frame(maxWidth: 390, alignment: .top)
                            .tag(1)
                        
                        EpisodeView(infoApi: infoApi, mangaApi: mangaApi, id: anilistId)
                            .fixedSize()
                            .frame(maxWidth: 390, alignment: .top)
                            .tag(2)
                        
                        CharacterView(infoApi: infoApi)
                            .fixedSize()
                            .frame(maxWidth: 390, alignment: .top)
                            .tag(3)
                        
                        RelatedView(infoApi: infoApi)
                            .fixedSize()
                            .frame(maxWidth: 390, alignment: .top)
                            .tag(4)
                        
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                        .indexViewStyle(.page(backgroundDisplayMode: .always))
                        .frame(height: 1300, alignment: .top)
                        .frame(maxWidth: 390, alignment: .top)
                        .animation(.spring(response: 0.3), value: selection)
                        .onChange(of: selection, perform: { index in
                            if(selection == 1) {
                                pillWidth = 78
                                paddingOffset = 238
                                paddingStyle = .trailing
                            } else if(selection == 2) {
                                pillWidth = 78
                                paddingOffset = 80
                                paddingStyle = .trailing
                            } else if(selection == 3) {
                                pillWidth = 88
                                paddingOffset = -90
                                paddingStyle = .trailing
                            } else {
                                pillWidth = 68
                                paddingOffset = 246
                                paddingStyle = .leading
                            }
                        })
                    
                }
                .ignoresSafeArea()
                
            }
            else {
                ScrollView {
                    ZStack(alignment: .bottom) {
                        AsyncImage(url: URL(string: "https://s4.anilist.co/file/anilistcdn/media/anime/banner/98659-u46B5RCNl9il.jpg")) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 390, height: 440)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Rectangle()
                            .fill(LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color(hex: "#0016151A"), location: 0),
                                    .init(color: Color(hex: "#9016151A"), location: 0.5),
                                    .init(color: Color(hex: "#ff16151A"), location: 1)
                                ]),
                                startPoint: UnitPoint(x: 0.0, y: 0),
                                endPoint: UnitPoint(x: 0.0, y: 1)))
                            .frame(width: 394, height: 440)
                            .ignoresSafeArea()
                        
                        AsyncImage(url: URL(string: "https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/b98659-sH5z5RfMuyMr.png")) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 176, height: 270)
                                .cornerRadius(20)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    
                    Text("Classroom of the Elite")
                        .bold()
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.top, 14)
                    Text("ようこそ実力至上主義の教室へ")
                        .bold()
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    ZStack {
                        Color(hex: "#ff1E222C")
                        Text("Koudo Ikusei Senior High School is a leading school with state-of-the-art facilities. The students there have the freedom to wear any hairstyle and bring any personal effects they desire. Koudo Ikusei is like a utopia, but the truth is that only the most superior students receive favorable treatment.<br><br>\n\nKiyotaka Ayanokouji is a student of D-class, which is where the school dumps its \"inferior\" students in order to ridicule them. For a certain reason, Kiyotaka was careless on his entrance examination, and was put in D-class. After meeting Suzune Horikita and Kikyou Kushida, two other students in his class, Kiyotaka's situation begins to change. <br><br>\n(Source: Anime News Network, edited)")
                            .foregroundColor(.white)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(.all, 20)
                    }
                    .frame(maxWidth: 350)
                    .cornerRadius(20)
                    .padding(.all, 20)
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 12) {
                            ForEach(0..<3) {genre in
                                ZStack {
                                    Color(.black)
                                    Text("GENRE")
                                        .foregroundColor(.white)
                                        .bold()
                                        .font(.caption)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 12)
                                }
                                .cornerRadius(40)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Text("Episodes")
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                        .frame(maxWidth: 340, alignment: .leading)
                        .padding(.top, 10)
                    
                    ScrollView {
                        VStack(spacing: 18) {
                            ForEach(0..<5) {index in
                                EpisodeCard(animeData: nil,title: "Hell is other people.", number: 1, thumbnail: "https://artworks.thetvdb.com/banners/episodes/329822/6190201.jpg", isFiller: false)
                            }
                        }
                        .frame(maxWidth: 350, alignment: .leading)
                    }
                    .frame(maxHeight: 500)
                }
                .ignoresSafeArea()
                .redacted(reason: .placeholder).shimmering(active: true)
            }
            
            Button(action: {
                self.presentation.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundColor(.white)
            })
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.leading, 20)
            
            // Bottom NavBar
            VStack(alignment: .trailing) {
                ZStack {
                    Color(.black)
                    
                    RoundedRectangle(cornerRadius: 19)
                        .fill(Color(#colorLiteral(red: 0.11764705926179886, green: 0.13333334028720856, blue: 0.1725490242242813, alpha: 1)))
                        .frame(width: pillWidth, height: 30)
                        .padding(paddingStyle, paddingOffset).animation(.spring(response: 0.3), value: selection)
                    
                    HStack {
                        
                        Spacer()
                        
                        Text("More Info")
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .bold))
                            .onTapGesture {
                                selection = 1
                                
                                // set pill to width 78, padding 238 trailing
                                pillWidth = 78
                                paddingOffset = 238
                                paddingStyle = .trailing
                            }
                        
                        Spacer()
                        
                        Text("Episodes")
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .bold))
                            .onTapGesture {
                                selection = 2
                                
                                // set pill to width 78, padding 80 trailing
                                pillWidth = 78
                                paddingOffset = 80
                                paddingStyle = .trailing
                            }
                        
                        Spacer()
                        
                        Text("Characters")
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .bold))
                            .onTapGesture {
                                selection = 3
                                
                                // set pill to width 88, padding -90 trailing
                                pillWidth = 88
                                paddingOffset = -90
                                paddingStyle = .trailing
                            }
                        
                        Spacer()
                        
                        Text("Related")
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .bold))
                            .onTapGesture {
                                selection = 4
                                
                                // set pill to width 68, padding 246 leading
                                pillWidth = 68
                                paddingOffset = 246
                                paddingStyle = .leading
                            }
                        
                        Spacer()
                    }
                }
                .frame(maxWidth: 340, maxHeight: 70)
                .cornerRadius(20)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 40)
            .ignoresSafeArea()
            .edgesIgnoringSafeArea(.all)
            
        }
        .onAppear() {
            infoApi.loadInfo(id: anilistId)
        }
        .supportedOrientation(.portrait)
        .prefersHomeIndicatorAutoHidden(true)
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


struct InfoPage_Previews: PreviewProvider {
    static var previews: some View {
        InfoPage(anilistId: "113415")
    }
}

class InfoApi : ObservableObject{
    @Published var infodata: InfoData? = nil
    
    func loadInfo(id: String) {
        guard let url = URL(string: "https://api.consumet.org/meta/anilist/info/\(id)?fetchFiller=true") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let books = try! JSONDecoder().decode(InfoData.self, from: data!)
            print(books)
            DispatchQueue.main.async {
                self.infodata = books
            }
        }.resume()
    }
}


