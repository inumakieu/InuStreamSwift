//
//  MangaReaderView.swift
//  Inus Stream
//
//  Created by Inumaki on 21.10.22.
//

import SwiftUI
import SwiftUIFontIcon

struct MangaReaderView: View {
    let mangaName: String
    let mangaTitle: String
    let mangaData: MangaInfo
    @State var chapterNumber: Int
    
    @StateObject var mangaApi = MangaApi()
    
    @State var offsetX: CGFloat = 0
    @State var tapped: CGFloat = 0
    @State var showUI: Bool = true
    @State var chapterNumberName: String = "c001"
    @State var maxChapter = 100
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.black)
            
            if(mangaApi.mangadata != nil && mangaApi.mangadata.count > 0) {
                ZStack {
                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
                            ForEach(0..<mangaApi.mangadata.count) {imageIndex in
                                CustomAsyncImage(imgUrl: mangaApi.mangadata[imageIndex].img, referer: mangaApi.mangadata[imageIndex].headerForImage.Referer) { image in
                                  image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 393)
                                    
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                        .offset(x: offsetX)
                    }
                    .animation(.spring(response: 0.3), value: tapped)
                    .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                        .onEnded({ value in
                                            if value.translation.width < 0 {
                                                // left
                                                if(Int(tapped) < mangaApi.mangadata.count - 1) {
                                                    tapped += 1
                                                } else {
                                                    tapped = CGFloat(mangaApi.mangadata.count - 1)
                                                }
                                            }

                                            if value.translation.width > 0 {
                                                // right
                                                if(Int(tapped) > 0) {
                                                    tapped -= 1
                                                } else {
                                                    tapped = 0
                                                }
                                                
                                            }
                                            offsetX = (393 * tapped) * -1
                                        }))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            
            ZStack {
                Color(hex: "#ff16151A")
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Spacer()
                        
                        VStack {
                            Text(mangaTitle)
                                .bold()
                                .foregroundColor(.white)
                                .lineLimit(2)
                            
                            Text("Chapter \(mangaData.chapters![chapterNumber].id.components(separatedBy: "/")[1].replacingOccurrences(of: "c", with: "").replacingOccurrences(of: "^0+", with: "", options: .regularExpression))")
                                .bold()
                                .foregroundColor(Color(hex: "#ff999999"))
                                .font(.footnote)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Color(hex: "#ff1E222C")
                            
                            FontIcon.button(.awesome5Solid(code: .sliders_h), action: {
                                
                            }, fontsize: 14)
                            .foregroundColor(.white)
                            .padding(12)
                        }
                        .fixedSize()
                        .cornerRadius(40)
                        .padding(.trailing, 20)
                    }
                    
                    Spacer()
                        .frame(maxHeight: 20)
                    
                    HStack {
                        ZStack {
                            Color(hex: "#ff1E222C")
                            
                            HStack {
                                FontIcon.button(.awesome5Solid(code: .chevron_left), action: {
                                    
                                }, fontsize: 10)
                                .foregroundColor(.white)
                                
                                Text("Prev. Chapter")
                                    .foregroundColor(.white)
                                    .bold()
                                    .font(.caption)
                            }
                            .padding(12)
                        }
                        .fixedSize()
                        .cornerRadius(8)
                        .onTapGesture {
                            if(chapterNumber > 0) {
                                chapterNumber += 1
                            }
                            if(chapterNumber < 10) {
                                chapterNumberName = "c00\(chapterNumber)"
                            } else {
                                chapterNumberName = "c0\(chapterNumber)"
                            }
                            mangaApi.mangadata = []
                            mangaApi.loadInfo(id: "\(mangaData.chapters![chapterNumber].id)")
                            tapped = 0
                            offsetX = 0
                        }
                        
                        Spacer()
                        
                        Text("\(Int(tapped) + 1) / \(mangaApi.mangadata.count)")
                            .foregroundColor(.white)
                            .bold()
                            .font(.footnote)
                            .bold()
                        
                        Spacer()
                        
                        ZStack {
                            Color(hex: "#ff1E222C")
                            
                            HStack {
                                Text("Next Chapter")
                                    .foregroundColor(.white)
                                    .bold()
                                    .font(.caption)
                                
                                FontIcon.button(.awesome5Solid(code: .chevron_right), action: {
                                    
                                }, fontsize: 10)
                                .foregroundColor(.white)
                            }
                            .padding(12)
                        }
                        .fixedSize()
                        .cornerRadius(8)
                        .onTapGesture {
                            if(chapterNumber < maxChapter) {
                                chapterNumber -= 1
                            }
                            if(chapterNumber < 10) {
                                chapterNumberName = "c00\(chapterNumber)"
                            } else {
                                chapterNumberName = "c0\(chapterNumber)"
                            }
                            mangaApi.mangadata = []
                            mangaApi.loadInfo(id: "\(mangaData.chapters![chapterNumber].id)")
                            tapped = 0
                            offsetX = 0
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .cornerRadius(20, corners: [.topLeft, .topRight])
            .opacity(showUI ? 1.0 : 0.0)
            .animation(.spring(response: 0.3), value: showUI)
            
            
        }
        .edgesIgnoringSafeArea(.all)
        .task {
            mangaApi.loadInfo(id: "\(mangaName)")
            
            maxChapter = mangaData.chapters?.count ?? 1
        }
    }
}



struct CustomAsyncImage<Content: View, Placeholder: View>: View {

  @State var uiImage: UIImage?

    let imgUrl: String
    let referer: String
  let content: (Image) -> Content
  let placeholder: () -> Placeholder

  init(
    imgUrl: String,
    referer: String,
      @ViewBuilder content: @escaping (Image) -> Content,
      @ViewBuilder placeholder: @escaping () -> Placeholder
  ){
      self.imgUrl = imgUrl
      self.referer = referer
      self.content = content
      self.placeholder = placeholder
  }

  var body: some View {
      if let uiImage = uiImage {
          content(Image(uiImage: uiImage))
      }else {
          placeholder()
              .task {
                  self.uiImage = await getImage(imgUrl: imgUrl, referer: referer)
              }
      }
  }
}

func getImage(imgUrl: String, referer: String) async -> UIImage? {
    guard let url = URL(string: imgUrl) else {
        fatalError("Missing URL")
    }
    
    var request = URLRequest(url: url)
    request.addValue(referer, forHTTPHeaderField: "Referer")
    
    do {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching attchment") }
        
        return UIImage(data: data)
    } catch {
        return nil
    }
    
}

class MangaApi : ObservableObject{
    @Published var mangadata = [MangaData]()
    @Published var mangainfo: MangaInfo? = nil
    
    
    func loadInfo(id: String) {
        guard let url = URL(string: "https://api.consumet.org/meta/anilist-manga/read?chapterId=\(id)&provider=mangahere") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let books = try! JSONDecoder().decode([MangaData].self, from: data!)
            //print(books)
            DispatchQueue.main.async {
                self.mangadata = books
            }
        }.resume()
    }
    
    func getInfo(id: String) async -> MangaInfo? {
        guard let url = URL(string: "https://api.consumet.org/meta/anilist-manga/info/\(id)?provider=mangahere") else {
            print("Invalid url...")
            return nil
        }
        
        let request = URLRequest(url: url)
        
        let (data, _) = try! await URLSession.shared.data(for: request)
        let result = try! JSONDecoder().decode(MangaInfo.self, from: data)
        return result
    }
}

struct MangaData: Codable {
    let page: Int
    let img: String
    let headerForImage: MangaReferer
}

struct MangaReferer: Codable {
    let Referer: String
}

struct MangaInfo: Codable {
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
    let type: String?
    let recommendations: [Recommended]?
    let characters: [Character]
    let relations: [Related]?
    let chapters: [MangaChapter]?
}

struct MangaChapter: Codable {
    let id: String
    let title: String
    let releasedDate: String
}
