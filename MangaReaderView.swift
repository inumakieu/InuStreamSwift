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
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.black)
            
            ZStack {
                CustomAsyncImage(getImage: getImage) { image in
                  image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                } placeholder: {
                    Text("PlaceHolder")
                }
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
                                
                            }, fontsize: 12)
                            .foregroundColor(.white)
                            .padding(16)
                        }
                        .fixedSize()
                        .cornerRadius(40)
                        .padding(.trailing, 20)
                    }
                    
                    HStack {
                        ZStack {
                            Color(hex: "#ff1E222C")
                            
                            HStack {
                                FontIcon.button(.awesome5Solid(code: .chevron_left), action: {
                                    
                                }, fontsize: 18)
                                .foregroundColor(.white)
                                
                                Text("Prev. Chapter")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                            .padding(12)
                        }
                        .fixedSize()
                        .cornerRadius(8)
                        
                        Spacer()
                        
                        Text("4 / 21")
                            .foregroundColor(.white)
                            .bold()
                            .font(.footnote)
                            .bold()
                        
                        Spacer()
                        
                        ZStack {
                            Color(hex: "#ff1E222C")
                            
                            HStack {
                                Text("Next Chpater")
                                    .foregroundColor(.white)
                                    .bold()
                                
                                FontIcon.button(.awesome5Solid(code: .chevron_right), action: {
                                    
                                }, fontsize: 18)
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
            .frame(height: 180)
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

  let getImage: () async -> UIImage?
  let content: (Image) -> Content
  let placeholder: () -> Placeholder

  init(
      getImage: @escaping () async -> UIImage?,
      @ViewBuilder content: @escaping (Image) -> Content,
      @ViewBuilder placeholder: @escaping () -> Placeholder
  ){
      self.getImage = getImage
      self.content = content
      self.placeholder = placeholder
  }

  var body: some View {
      if let uiImage = uiImage {
          content(Image(uiImage: uiImage))
      }else {
          placeholder()
              .task {
                  self.uiImage = await getImage()
              }
      }
  }
}

func getImage() async -> UIImage? {
    guard let url = URL(string: "https://zjcdn.mangahere.org/store/manga/20993/001.0/compressed/f001.jpg") else {
        fatalError("Missing URL")
    }
    
    var request = URLRequest(url: url)
    request.addValue("http://www.mangahere.cc/manga/youkoso_jitsuryoku_shijou_shugi_no_kyoushitsu_e/c001/1.html", forHTTPHeaderField: "Referer")
    
    do {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching attchment") }
        
        return UIImage(data: data)
    } catch {
        return nil
    }
    
}
