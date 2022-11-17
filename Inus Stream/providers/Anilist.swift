//
//  Anilist.swift
//  Inus Stream
//
//  Created by Inumaki on 25.10.22.
//

import Foundation

class Anilist : ObservableObject{
    @Published var trendingData = [TrendingData]()
    @Published var recentsData = [RecentData]()
    @Published var infodata: InfoData? = nil
    
    let baseUrl: String = "https://api.consumet.org/meta/anilist"
    
    func getTrending() {
        guard let url = URL(string: "\(baseUrl)/trending") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let trending = try! JSONDecoder().decode(TrendingResults.self, from: data!)
            DispatchQueue.main.async {
                self.trendingData = trending.results
            }
        }.resume()
    }
    
    func getRecents() {
        guard let url = URL(string: "\(baseUrl)/recent-episodes") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let recents = try! JSONDecoder().decode(RecentResults.self, from: data!)
            DispatchQueue.main.async {
                self.recentsData = recents.results
            }
        }.resume()
    }
    
    func getInfo(id: String) {
        guard let url = URL(string: "\(baseUrl)/info/\(id)?fetchFiller=true") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let info = try! JSONDecoder().decode(InfoData.self, from: data!)
            DispatchQueue.main.async {
                self.infodata = info
            }
        }.resume()
    }
}
