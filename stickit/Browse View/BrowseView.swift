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
    @State var selection: String = "swatch_shipcove"
    @State var validateAlert: Bool = false
    
    let selectedModel = Model()
    
    var body: some View{
        NavigationView{
            
            VStack(alignment: .leading) {
                TextField("Enter notes...", text: $notes, onEditingChanged: { (changed) in
                    print("Username onEditingChanged - \(changed)")
                }) {
                    
                    if notes.isEmpty{
                        validateAlert.toggle()
                    }else{
                        selectedModel.notes = notes
                        self.placementSettings.selectedModel = selectedModel
                        print("Selected Model Set")
                    }
                    
                    }.alert(isPresented: $validateAlert){
                        Alert(title: Text("Error"), message: Text("Enter your notes first please"), dismissButton: .default(Text("Lets Go")))
                   
                }.padding(.bottom,20).padding(.top,5)
                
//                Spacer().frame(width: 50, height: 50, alignment: .leading)
                
                Text("Choose color :")
                
                ColorSwatchView(selection: $selection)
                
                HStack{
                    Spacer()
                    
                    Button(action:{
                        print("Insert button pressed")
                        if notes.isEmpty{
                            validateAlert.toggle()
                        }else{
                            selectedModel.notes = notes
                            self.placementSettings.selectedModel = selectedModel
                            print("Selected Model Set")
                        }
                    }){
                        Text("Insert")
                            .bold()
                            .frame(width: 150 , height: 20, alignment: .center)
                        
                            .alert(isPresented: $validateAlert){
                                Alert(title: Text("Error"), message: Text("Enter your notes first please"), dismissButton: .default(Text("Lets Go")))
                            }
                    }.padding()
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .cornerRadius(8)
                        
                    
                    Spacer()
                }
                
                Spacer()
                
                }.padding()
            
            
            .navigationBarTitle(Text("Add Notes"), displayMode: .large)
            .navigationBarItems(trailing:
                                    Button(action: {
                self.showBrowse.toggle()
            }){
                Text("Done").bold()
            })
        }
    }
}
