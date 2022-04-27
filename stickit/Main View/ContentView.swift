//
//  ContentView.swift
//  stickit
//
//  Created by Hansel Matthew on 25/04/22.
//

import SwiftUI
import RealityKit
import RealityUI



struct ContentView: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @State private var isControlVisible: Bool = true
    @State private var showBrowse: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom){
            ARViewContainer()
            
            if self.placementSettings.selectedModel?.notes == nil{
                ControlView(isControlVisible: $isControlVisible, showBrowse: $showBrowse)
            } else {
                PlacementView()
            }
            
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable{
    @EnvironmentObject var placementSettings: PlacementSettings
    
    func makeUIView(context: Context) -> CustomARView {
            let arView = CustomARView(frame: .zero)
        
        //Subsribe to SceneEvents.Update
        self.placementSettings.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self, {(event) in
            
            
            
            self.updateScene(for: arView)
            
        })
            
            return arView
        }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {

    }
    
    private func updateScene(for arView: CustomARView){
        
        //Only display focusEntity when model has been selected
        arView.focusEntity?.isEnabled =  self.placementSettings.selectedModel != nil
        
        //Add model to scene
        if let confirmedModel = self.placementSettings.confirmedModel, let notes = confirmedModel.notes {
            
            self.place(notes,in: arView)
            
            self.placementSettings.confirmedModel = nil
        }
        
        
    }
    
    private func place(_ notes: String, in arView: ARView){
        RealityUI.registerComponents()
        RealityUI.startingOrientation = simd_quatf(angle: .pi, axis: [0, 1, 0])
        print("Placing Entity")
        let textEntity = RUIText(with: notes, width: 100, height: 1,font: RUIText.mediumFont, extrusion: 0.01, color: .yellow)
        textEntity.transform.scale *= 0.3
        arView.installGestures([.translation, .rotation], for: textEntity)
        let anchorEntity =  AnchorEntity(plane: .any)
        anchorEntity.addChild(textEntity)
        arView.scene.addAnchor(anchorEntity)
        print("Entity Placed")
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .environmentObject(PlacementSettings())
//    }
//}
