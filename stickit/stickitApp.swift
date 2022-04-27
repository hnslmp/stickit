//
//  stickitApp.swift
//  stickit
//
//  Created by Hansel Matthew on 25/04/22.
//

import SwiftUI

@main
struct stickitApp: App {
    @StateObject var placementSettings = PlacementSettings()
    @StateObject var sceneManager = SceneManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(placementSettings)
                .environmentObject(sceneManager)
        }
    }
}
