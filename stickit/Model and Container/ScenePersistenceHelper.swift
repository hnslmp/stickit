//
//  ScenePersistenceHelper.swift
//  stickit
//
//  Created by Hansel Matthew on 27/04/22.
//

import Foundation
import RealityKit
import ARKit

class ScenePersistenceHelper {
    
    class func saveScene(for arView: CustomARView, at persistenceURL: URL){
        print("Save Scene to local filesystem")
        
        // 1. Get Current worldmap data from arview session
        arView.session.getCurrentWorldMap{ worldMap, error in
            
            //2. Unwrap world map
            guard let map = worldMap  else{
                print("Persistence Error: Unable to get world Map: \(error!.localizedDescription)")
                return
            }
            
            //3.Archive data and write to filesystem
            do{
                let sceneData = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                
                try sceneData.write(to: persistenceURL, options: [.atomic])
            }catch{
                print("Persistence Error: Can't save scene to local filesystem: \(error.localizedDescription)")
            }
        }
    }
    
    class func loadScene(for arView: CustomARView, with scenePersistenceData:  Data){
        print("Load Scene from local filesystem")

        //1. Unarchive scenePersistenceData and retrieve ARWorldMap
        let worldMap: ARWorldMap = {
            do {
                guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: scenePersistenceData) else {
                    fatalError("Persistence Error: No ARWorldMap in archive")
                }
                
                return worldMap
            } catch {
                
                fatalError("Persistence Error: No ARWorldMap in archive")
            }
        }()
        
        //2. Reset configuration and load worldMap as initialWorldMap
        let newConfig  = arView.defaultConfiguration
        newConfig.initialWorldMap = worldMap
        arView.session.run(newConfig, options: [.resetTracking, .removeExistingAnchors])
    }
    
}
