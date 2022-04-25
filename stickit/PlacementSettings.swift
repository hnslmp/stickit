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
    @Published var selectedModel: String?{
        willSet(newValue){
            print("Setting selectedModel to \(String(describing: newValue))")
        }
    }
    
    @Published var confirmedModel: String?{
        willSet(newValue){
            guard let model = newValue else {
                print("Clearing confirmedModel")
                return
            }
            print("Setting confirmedModel \(model)")
        }
    }
}
