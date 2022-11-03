//
//  HomePageWrapperView.swift
//  Inus Stream
//
//  Created by Inumaki on 29.10.22.
//

import SwiftUI

struct HomePageWrapperView: View {
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .mac || UIDevice.current.userInterfaceIdiom == .pad {
            HomePageMac()
        } else {
            HomePage()
        }
        
    }
}

struct HomePageWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageWrapperView()
    }
}
