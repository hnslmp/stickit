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
        print("Placing Entity")
        
        
//        let box = MeshResource.generateBox(size: 0.3) // Generate mesh
//        let entity = ModelEntity(mesh: box) // Create an entity from mesh
      
        
//        let textEntity = ModelEntity(mesh: .generateText("Hello there", extrusionDepth: 0.4, font: .boldSystemFont(ofSize: 8), containerFrame: .zero, alignment: .center, lineBreakMode: .byWordWrapping))
//        let text = MeshResource.generateText("Hello there", extrusionDepth: 0.4, font: .systemFont(ofSize: 32), containerFrame: .zero, alignment: .center, lineBreakMode: .byWordWrapping)
        let textEntity = RUIText(with: notes, width: 100, height: 1,font: RUIText.mediumFont, extrusion: 0.01, color: .yellow)
        textEntity.transform.scale *= 0.3
//        textEntity.look(at: [0, 1.5, 0], from: [0, 1.5, -1], relativeTo: nil)
//        let textEntity = ModelEntity(mesh: text)
        
        
        arView.installGestures([.translation, .rotation], for: textEntity)
        let anchorEntity =  AnchorEntity(plane: .any)
        anchorEntity.addChild(textEntity)
        arView.scene.addAnchor(anchorEntity)
        
        print("Entity Placed")
        
    }
    
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PlacementSettings())
    }
}
