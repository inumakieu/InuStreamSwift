//
//  SceneDelegate.swift
//  Anime Now! (iOS)
//
//  Created by Erik Bautista on 10/9/22.
//
import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let dataController = DataController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = HostingController(
                wrappedView:
                    HomePage().environment(\.managedObjectContext, dataController.container.viewContext)
            )
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
