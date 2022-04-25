//
//  ContentView.swift
//  stickit
//
//  Created by Hansel Matthew on 25/04/22.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @State private var isControlVisible: Bool = true
    @State private var showBrowse: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom){
            ARViewContainer()
            
            if self.placementSettings.selectedModel == nil{
                ControlView(isControlVisible: $isControlVisible, showBrowse: $showBrowse)
            } else {
                PlacementView()
            }
            
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable{
    func makeUIView(context: Context) -> ARView {
            let arView = ARView(frame: .zero)
            
            return arView
        }
    
    func updateUIView(_ uiView: ARView, context: Context) {

    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PlacementSettings())
    }
}
