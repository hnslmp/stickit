//
//  ARViewContainer.swift
//  stickit
//
//  Created by Hansel Matthew on 27/04/22.
//

import SwiftUI
import RealityKit
import RealityUI

struct ARViewContainer: UIViewRepresentable{
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var sceneManager: SceneManager
    
    func makeUIView(context: Context) -> CustomARView {
            let arView = CustomARView(frame: .zero)
        
        //Subsribe to SceneEvents.Update
        self.placementSettings.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self, {(event) in
            
            self.updateScene(for: arView)
            
            self.updatePersistenceAvailability(for: arView)
            
        })
            
            return arView
        }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {

    }
    
    private func updateScene(for arView: CustomARView){
        
        //Only display focusEntity when model has been selected
        arView.focusEntity?.isEnabled =  self.placementSettings.selectedModel != nil
        
        //Add model to scene
        if let confirmedModel = self.placementSettings.confirmedModel {
            
            //Place model
            self.place(confirmedModel,in: arView)
            
            //Clear Model
            self.placementSettings.confirmedModel = nil
        }
        
        
    }
    
    private func place(_ confirmedModel: Model, in arView: ARView){
        
        //Resgiter RUI
        RealityUI.registerComponents()
        
        //Rotate orientation
        RealityUI.startingOrientation = simd_quatf(angle: .pi, axis: [0, 1, 0])
        print("Placing Entity")
        
        //Create Text Entity
        let textColor = UIColor(named: confirmedModel.color ?? "swatch_schooner")!
        let textEntity = RUIText(with: confirmedModel.notes!, width: 100, height: 1,font: RUIText.mediumFont, extrusion: 0.01, color: textColor)
        textEntity.transform.scale *= 0.1
        arView.installGestures([.translation, .rotation], for: textEntity)
        
        //Create anchor and add entity
        let anchorEntity =  AnchorEntity(plane: .any)
        anchorEntity.addChild(textEntity)
        arView.scene.addAnchor(anchorEntity)
        
        //Add entity to array entities
        self.sceneManager.anchorEntities.append(anchorEntity)
        
        print("Entity Placed")
    }
}

// MARK: - Persistence

class SceneManager: ObservableObject{
    @Published var isPersistenceAvailable: Bool = false
    @Published var anchorEntities: [AnchorEntity] = [] //Keep track of all anchor entity
}

extension ARViewContainer{
    private func updatePersistenceAvailability(for arView: ARView){
        guard let currentFrame = arView.session.currentFrame else{
            print("ARFrame not available")
            return
        }
        
        switch currentFrame.worldMappingStatus {
        case .mapped, .extending:
            self.sceneManager.isPersistenceAvailable  =  !self.sceneManager.anchorEntities.isEmpty
        default:
            self.sceneManager.isPersistenceAvailable = false
        }
    }
}
