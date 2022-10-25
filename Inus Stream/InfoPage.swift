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

struct ExtraInfoView: View {
    let infoApi: InfoApi
    
    var body: some View {
        
        ZStack {
            Color(hex: "#ff1E222C")
            
            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading) {
                    Text("Synonyms")
                        .bold()
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer().frame(maxHeight: 6)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(0..<infoApi.infodata!.synonyms!.count) {synonym in
                            Text("\(infoApi.infodata!.synonyms![synonym])")
                                .bold()
                                .foregroundColor(Color(hex: "#ff999999"))
                                .font(.title3)
                                .bold()
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                }
                
                VStack(alignment: .leading) {
                    Text("Country of Origin")
                        .bold()
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer().frame(maxHeight: 6)
                    
                    Text(infoApi.infodata!.countryOfOrigin!)
                        .bold()
                        .foregroundColor(Color(hex: "#ff999999"))
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                }
                
                VStack(alignment: .leading) {
                    Text("Format")
                        .bold()
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer().frame(maxHeight: 6)
                    
                    Text(infoApi.infodata!.type!)
                        .bold()
                        .foregroundColor(Color(hex: "#ff999999"))
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                }
                
                VStack(alignment: .leading) {
                    Text("Studios")
                        .bold()
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer().frame(maxHeight: 6)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(0..<infoApi.infodata!.studios.count) {studio in
                            Text("\(infoApi.infodata!.studios[studio])")
                                .bold()
                                .foregroundColor(Color(hex: "#ff999999"))
                                .font(.title3)
                                .bold()
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                }
                
                VStack(alignment: .leading) {
                    Text("Duration")
                        .bold()
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer().frame(maxHeight: 6)
                    
                    Text("\(infoApi.infodata!.duration!)")
                        .bold()
                        .foregroundColor(Color(hex: "#ff999999"))
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                }
                
                VStack(alignment: .leading) {
                    Text("Episodes")
                        .bold()
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer().frame(maxHeight: 6)
                    
                    Text("\(infoApi.infodata!.totalEpisodes!)")
                        .bold()
                        .foregroundColor(Color(hex: "#ff999999"))
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                }
                
                VStack(alignment: .leading) {
                    Text("Status")
                        .bold()
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer().frame(maxHeight: 6)
                    
                    Text("\(infoApi.infodata!.status.uppercased())")
                        .bold()
                        .foregroundColor(Color(hex: "#ff999999"))
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                }
                
                VStack(alignment: .leading) {
                    Text("Released in")
                        .bold()
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer().frame(maxHeight: 6)
                    
                    Text("\(infoApi.infodata!.releaseDate)")
                        .bold()
                        .foregroundColor(Color(hex: "#ff999999"))
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                }
                
                VStack(alignment: .leading) {
                    Text("Season")
                        .bold()
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer().frame(maxHeight: 6)
                    
                    Text("\(infoApi.infodata!.season!)")
                        .bold()
                        .foregroundColor(Color(hex: "#ff999999"))
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                }
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxHeight: 1300, alignment: .top)
            .padding(.all, 30)
        }
        .cornerRadius(20)
        .padding(.all, 20)
        .frame(width: 390)
        .frame(maxWidth: .infinity, alignment: .top)
        .frame(height: 1300, alignment: .top)
        .frame(maxHeight: 1300, alignment: .top)
        .cornerRadius(20)
        .padding(.top, 20)
        
    }
}

struct EpisodeView: View {
    let infoApi: InfoApi
    let mangaApi: MangaApi
    let id: String
    @State var moveToManga: Bool = false
    @State var isManga: Bool = false
    @State var mangaData: MangaInfo? = nil
    
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
            
            Text("\(mangaData != nil ? "Chapters" : "Episodes")")
                .foregroundColor(.white)
                .font(.title)
                .bold()
                .frame(maxWidth: 340, alignment: .leading)
                .padding(.top, 10)
            
            if(!isManga) {
                ScrollView {
                    VStack(spacing: 18) {
                        ForEach(0..<infoApi.infodata!.episodes!.count) {index in
                            EpisodeCard(animeData: infoApi.infodata!,title: infoApi.infodata!.episodes![index].title ?? infoApi.infodata!.title.romaji, number: infoApi.infodata!.episodes![index].number, thumbnail: infoApi.infodata!.episodes![index].image, isFiller: infoApi.infodata!.episodes![index].isFiller
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

struct ChapterView: View {
    let mangaChapter: MangaChapter
    let animeImage: String
    let chapterNumber: Int
    let englishTitle: String
    let mangaData: MangaInfo
    
    var body: some View {
        NavigationLink(destination: MangaReaderView(mangaName: mangaChapter.id, mangaTitle: englishTitle, mangaData: mangaData, chapterNumber: chapterNumber)) {
            HStack {
                AsyncImage(url: URL(string: animeImage)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 90, height: 130)
                        .cornerRadius(12)
                } placeholder: {
                    ProgressView()
                }
                
                Spacer()
                    .frame(width: 12)
                    .frame(maxWidth: 12)
                
                VStack {
                    Text("\(mangaChapter.title)")
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("Chapter \(mangaChapter.id.components(separatedBy: "/")[1].replacingOccurrences(of: "c", with: "").replacingOccurrences(of: "^0+", with: "", options: .regularExpression))")
                        .bold()
                        .foregroundColor(Color(hex: "#ff999999"))
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(width: 350, alignment: .leading)
            .frame(height: 1300, alignment: .top)
            .frame(maxHeight: 1300, alignment: .top)
        }
    }
}


struct CharacterView: View {
    let infoApi: InfoApi
    
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
            .frame(height: 1300, alignment: .top)
            .frame(maxHeight: 1300, alignment: .top)
        }
        
    }
}

struct RelatedView: View {
    let infoApi: InfoApi
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.vertical) {
                ForEach(0..<infoApi.infodata!.relations!.count) {relIndex in
                    HStack {
                        AsyncImage(url: URL(string: infoApi.infodata!.relations![relIndex].image)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 105, height: 145)
                                .cornerRadius(12)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        VStack(alignment: .leading) {
                            Text("\(infoApi.infodata!.relations![relIndex].title.english ?? infoApi.infodata!.relations![relIndex].title.romaji)")
                                .foregroundColor(.white)
                                .bold()
                                .font(.title2)
                                .lineLimit(2)
                            
                            Text("\(infoApi.infodata!.relations![relIndex].title.native)")
                                .foregroundColor(Color(hex: "#ff999999"))
                                .bold()
                                .font(.caption)
                            
                            HStack {
                                Text("\(infoApi.infodata!.relations![relIndex].status)")
                                    .foregroundColor(.white)
                                    .bold()
                                
                                Spacer()
                                
                                Text("\(infoApi.infodata!.relations![relIndex].type!)")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: 330)
        .frame(height: 1300, alignment: .top)
        .frame(maxHeight: 1300, alignment: .top)
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

struct InfoData: Codable {
    let id: String
    let title: Title
    let malId: Int?
    let synonyms: [String]?
    let isLicensed, isAdult: Bool?
    let countryOfOrigin: String?
    let trailer: Trailer?
    let image: String
    let popularity: Int
    let color: String?
    let cover: String
    let description, status: String
    let releaseDate: Int
    let startDate, endDate: EndDateClass
    let nextAiringEpisode: AiringData?
    let totalEpisodes: Int?
    let duration: Int?
    let rating: Int?
    let genres: [String]
    let season: String?
    let studios: [String]
    let subOrDub: String
    let type: String?
    let recommendations: [Recommended]?
    let characters: [Character]
    let relations: [Related]?
    let episodes: [Episode]?
}

struct AiringData: Codable {
    let airingTime: Int
    let timeUntilAiring: Int
    let episode: Int
}

struct Recommended: Codable {
    let id: Int?
    let malId: Int?
    let title: Title
    let status: String
    let episodes: Int?
    let image, cover: String
    let rating: Int?
    let type: String?
}

struct Character: Codable {
    let id: Int?
    let role: String
    let name: Name
    let image: String
    let voiceActors: [VoiceActor]?
}

struct Related: Codable {
    let id: Int?
    let relationType: String
    let malId: Int?
    let title: Title
    let status: String
    var episodes: Int?
    let image: String
    let color, type: String?
    let cover: String
    let rating: Int?
}

struct Episode: Codable {
    let id: String
    let title: String?
    let description: String?
    let number: Int
    let image: String
    let isFiller: Bool?
}

// MARK: - Name
struct Name: Codable {
    let first, last, full: String?
    let native: String?
    let userPreferred: String
}

// MARK: - VoiceActor
struct VoiceActor: Codable {
    let id: Int
    let name: Name
    let image: String
}

// MARK: - EndDateClass
struct EndDateClass: Codable {
    let year: Int?
    let month: Int?
    let day: Int?
}

// MARK: - Title
struct Title: Codable {
    let romaji, native: String
    let english: String?
}

// MARK: - Trailer
struct Trailer: Codable {
    let id, site: String
    let thumbnail: String
}
