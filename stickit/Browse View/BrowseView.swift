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
    @State var selectionColor: String = "swatch_shipcove"
    @State var validateAlert: Bool = false
    
    let selectedModel = Model()
    
    var body: some View{
        NavigationView{
            
            //Enter notes text edit
            VStack(alignment: .leading) {
                TextField("Enter notes...", text: $notes, onEditingChanged: { (changed) in
                    print("Username onEditingChanged - \(changed)")
                }) {
                    
                    if notes.isEmpty{
                        validateAlert.toggle()
                    }else{
                        selectedModel.notes = notes
                        selectedModel.color = selectionColor
                        self.placementSettings.selectedModel = selectedModel
                        print("Selected Model Set")
                    }
                    
                    }.alert(isPresented: $validateAlert){
                        Alert(title: Text("Error"), message: Text("Enter your notes first please"), dismissButton: .default(Text("Lets Go")))
                   
                }.padding(.bottom,20).padding(.top,5)
                
                //Choose color text
                Text("Choose color :")
                
                //Color swatch
                ColorSwatchView(selection: $selectionColor)
                
                //Insert Button Hstack
                HStack{
                    
                    //Left Spacer
                    Spacer()
                    
                    //Insert Button
                    Button(action:{
                        print("Insert button pressed")
                        if notes.isEmpty{
                            validateAlert.toggle()
                        }else{
                            selectedModel.notes = notes
                            selectedModel.color = selectionColor
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
                        
                    //Right Spacer
                    Spacer()
                }
                
                //Bottom Spacer
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
