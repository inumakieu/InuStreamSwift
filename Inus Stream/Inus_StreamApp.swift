//
//  Inus_StreamApp.swift
//  Inus Stream
//
//  Created by L Lawliet on 19.09.22.
//

import SwiftUI


struct Inus_StreamApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            HomePage()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environment(\.colorScheme, .dark)
        }
    }
}

