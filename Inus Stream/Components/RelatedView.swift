//
//  RelatedView.swift
//  Inus Stream
//
//  Created by Inumaki on 25.10.22.
//

import SwiftUI

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
