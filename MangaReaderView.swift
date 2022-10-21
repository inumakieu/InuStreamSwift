//
//  MangaReaderView.swift
//  Inus Stream
//
//  Created by Inumaki on 21.10.22.
//

import SwiftUI
import SwiftUIFontIcon

struct MangaReaderView: View {
    let images = [
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f001.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f002.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f003.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f004.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f005.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f006.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f007.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f008.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f009.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f010.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f011.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f012.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f013.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f014.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f015.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f016.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f016.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f017.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f018.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f019.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f020.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f021.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f022.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f023.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f024.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f025.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f026.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f027.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f028.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f029.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f030.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f031.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f032.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f033.jpg",
        "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/b033.jpg"
    ]
    
    @State var offsetX: CGFloat = 0
    @State var tapped: CGFloat = 0
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.black)
            
            ZStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(0..<images.count) {imageIndex in
                            CustomAsyncImage(imgUrl: images[imageIndex], referer: "http://www.mangahere.cc/manga/youkoso_jitsuryoku_shijou_shugi_no_kyoushitsu_e/c001/1.html") { image in
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
                                            if(Int(tapped) < images.count - 1) {
                                                tapped += 1
                                            } else {
                                                tapped = CGFloat(images.count - 1)
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
            
            ZStack {
                Color(hex: "#ff16151A")
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Spacer()
                        
                        VStack {
                            Text("Classroom of the Elite")
                                .bold()
                                .foregroundColor(.white)
                            
                            Text("Chapter 1")
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
                        
                        Spacer()
                        
                        Text("\(Int(tapped) + 1) / \(images.count)")
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
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .cornerRadius(20, corners: [.topLeft, .topRight])
            
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct MangaReaderView_Previews: PreviewProvider {
    static var previews: some View {
        MangaReaderView()
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
