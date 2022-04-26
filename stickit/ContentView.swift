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
            
            //TODO: Call Place Method

            self.placementSettings.confirmedModel = nil
        }
        
        
    }
    
    private func place(_ notes: String, in arView: ARView){
//        let label = Label(notes,systemImage: "folder.circle")
//        let anchorEntity =  AnchorEntity(plane: .any)
//        let textAnchor = try! SomeText.loadTextScene()
//
//        let textEntity: Entity = textAnchor.vacation!.children[0].children[0]
//
//        var textModelComponent: ModelComponent = (textEntity.components[ModelComponent])!
//
//        textModelComponent.mesh = .generateText("Hello, World!",
//                                 extrusionDepth: 0.5,
//                                           font: .systemFont(ofSize: 0.25),
//                                 containerFrame: CGRect.zero,
//                                      alignment: .center,
//                                  lineBreakMode: .byCharWrapping)
//
//
//        anchorEntity.addChild(label)
        
    }
    
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PlacementSettings())
    }
}


