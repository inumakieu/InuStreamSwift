//
//  ChapterView.swift
//  Inus Stream
//
//  Created by Inumaki on 25.10.22.
//

import SwiftUI

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
