//
//  ContentView.swift
//  stickit
//
//  Created by Hansel Matthew on 25/04/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @State private var isControlVisible: Bool = true
    @State private var showBrowse: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom){
            ARViewContainer()
            
            //Display control view if model is empty
            if self.placementSettings.selectedModel?.notes == nil{
                ControlView(isControlVisible: $isControlVisible, showBrowse: $showBrowse)
            } else { //Place model if selected
                PlacementView()
            }
            
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

//struct ContentView_Previews: PreviewProvider{
//    static var previews: some View{
//        ContentView()
//            .environmentObject(PlacementSettings())
//            .environmentObject(SceneManager())
//    }
//}
