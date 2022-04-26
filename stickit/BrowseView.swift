//
//  BrowseView.swift
//  stickit
//
//  Created by Hansel Matthew on 25/04/22.
//

import SwiftUI

struct BrowseView: View{
    @EnvironmentObject var placementSettings: PlacementSettings
    @Binding var showBrowse: Bool
    @State var notes: String = ""
    
    let selectedModel = Model()
    
    var body: some View{
        NavigationView{
            
            VStack(alignment: .leading) {
                        TextField("Enter username...", text: $notes, onEditingChanged: { (changed) in
                            print("Username onEditingChanged - \(changed)")
                            
                            
                        }) {
                            selectedModel.notes = notes
                            self.placementSettings.selectedModel = selectedModel
                            print("Selected Model Set")
                        }
                        
                        Text("Your username: \(notes)")
                    }.padding()
            
            
            .navigationBarTitle(Text("Browse"), displayMode: .large)
            .navigationBarItems(trailing:
                                    Button(action: {
                self.showBrowse.toggle()
            }){
                Text("Done").bold()
            })
        }
    }
}
