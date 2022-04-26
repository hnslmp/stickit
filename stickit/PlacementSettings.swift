//
//  PlacementSettings.swift
//  stickit
//
//  Created by Hansel Matthew on 25/04/22.
//

import SwiftUI
import RealityKit
import Combine

class PlacementSettings: ObservableObject{
    @Published var selectedModel: Model?{
        willSet(newValue){
            print("Setting selectedModel to \(String(describing: newValue?.notes))")
        }
    }
    
    @Published var confirmedModel: Model?{
        willSet(newValue){
            guard let model = newValue else {
                print("Clearing confirmedModel")
                return
            }
            print("Setting confirmedModel \(model.notes)")
        }
    }
    
    //This property retains the cancellable object for sceneEvents.Update subscriber
    var sceneObserver: Cancellable?
}
