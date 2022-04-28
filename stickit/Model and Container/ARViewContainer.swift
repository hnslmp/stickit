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
            
            //Being called at every frame
            self.updateScene(for: arView)
            self.updatePersistenceAvailability(for: arView)
            self.handlePersistence(for: arView)
            
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
        
//        //Resgiter RUI
        RealityUI.registerComponents()

//        //Rotate orientation
        RealityUI.startingOrientation = simd_quatf(angle: .pi, axis: [0, 1, 0])
        print("Placing Entity")

        //Create Text Entity
        let textColor = UIColor(named: confirmedModel.color ?? "swatch_schooner")!
        let textEntity = RUIText(with: confirmedModel.notes!, width: 100, height: 1,font: RUIText.mediumFont, extrusion: 0.01, color: textColor)
        
//        textEntity.transform = Transform(pitch: 0, yaw: 1, roll: 0)
        textEntity.transform.scale *= 0.05//        Transform(scale: textScale, rotation: 1, translation: 0)
//        textEntity.transform = Transform(pitch: -1, yaw: 0, roll: 0)
        arView.installGestures([.translation, .rotation], for: textEntity)
        
        
//        let planeMesh = generatePlane(width: 50, depth: 50, cornerRadius: 2)
//        let planeEntity = ModelEntity(mesh: .generatePlane(width: 5, depth: 5, cornerRadius: 2))
        
        var simpleMaterial = SimpleMaterial()
        simpleMaterial.baseColor = MaterialColorParameter.color(UIColor(named: "notesColor")!)
        
        let planeEntity = ModelEntity(mesh: .generatePlane(width: 0.2, height: 0.1),materials: [simpleMaterial])
         // Make a model from a plate mesh with a width of 0.2m and a height of 0.3m.
        planeEntity.transform = Transform(pitch: 0, yaw: 0, roll: 0)
//        ModelEntity(mesh = .generatePlane(width: 50, depth: 50, cornerRadius: 2))
        arView.installGestures([.translation, .rotation], for: planeEntity)
        
//        let textEntity = ModelEntity(mesh: .generateTex)
        
        //Create anchor and add entity
        let anchorEntity =  AnchorEntity(plane: .any)
        
        anchorEntity.addChild(planeEntity)
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
    
    var shouldSaveSceneToFilesystem: Bool  = false //Flag for saving scene
    var shouldLoadSceneFromFilesystem: Bool = false //Flag for loading scene
    
    lazy var persistenceURL: URL = {
        //Contain url location to contain scene data
        do{
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("arf.persistence")
        } catch {
            fatalError("Unable to get persistenceURL: \(error.localizedDescription)")
        }
    }()
    
    var scenePersistenceData: Data? {
        return try? Data(contentsOf: persistenceURL)
    }
    
    
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
    
    private func handlePersistence(for arView: CustomARView){
        
        //When save scene triggered
        if self.sceneManager.shouldSaveSceneToFilesystem{
            
            //Save the scene
            ScenePersistenceHelper.saveScene(for: arView, at: self.sceneManager.persistenceURL)
            
            //Reset save flag
            self.sceneManager.shouldSaveSceneToFilesystem = false
            
        }
        //When load scene triggered
        else if self.sceneManager.shouldLoadSceneFromFilesystem {
            guard let scenePersistenceData = self.sceneManager.scenePersistenceData else {
                print("Unable to retrieve scenePersistenceData. Canceled loadScene operation.")
                
                self.sceneManager.shouldLoadSceneFromFilesystem = false
                
                return
            }
            
            //Load the scene
            ScenePersistenceHelper.loadScene(for: arView, with: scenePersistenceData)
            
            //Clear all entities data
            self.sceneManager.anchorEntities.removeAll(keepingCapacity: true)
            
            //Reset load flag
            self.sceneManager.shouldLoadSceneFromFilesystem = false
        }
    }
}
