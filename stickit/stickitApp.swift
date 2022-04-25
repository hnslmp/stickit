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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(placementSettings)
        }
    }
}
