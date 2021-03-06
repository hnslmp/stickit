//
//  ControlView.swift
//  stickit
//
//  Created by Hansel Matthew on 25/04/22.
//

import SwiftUI

struct ControlView: View{
    @Binding var isControlVisible: Bool
    @Binding var showBrowse: Bool
    
    var body: some View{
        VStack{
            
            ControlVisibilityToggleButton(isControlVisible: $isControlVisible)
            
            Spacer()
            
            if isControlVisible{
                ControlButtonBar(showBrowse: $showBrowse)
            }
        }
    }
}

struct ControlVisibilityToggleButton: View{
    @State private var showingInfo = false
    @Binding var isControlVisible: Bool
    
    var body: some View{
        HStack{
            
            //Visibility Button
            ZStack{
                Color.black.opacity(0.25)
                
                Button(action:{
                    print("Control Visibility pressed")
                    self.isControlVisible.toggle()
                }){
                    Image(systemName: self.isControlVisible ? "eye.slash" : "eye")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8.0)
            
            Spacer()
            
            //Info Button
            ZStack{
                Color.black.opacity(0.25)
                
                Button(action:{
                    print("Info Button pressed")
                    showingInfo = true
                }){
                    Image(systemName: "info.circle")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .buttonStyle(PlainButtonStyle())
                    
                        .alert(isPresented: $showingInfo){
                            Alert(title: Text("Info"), message: Text("Press 􀈂 to load saved expeience \n Press 􀈊 to insert a new note \n Press 􀈄 to save experience"), dismissButton: .default(Text("Lets Go")))
                        }
                }
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8.0)
        }
        .padding(.top,45)
        .padding(.trailing, 20)
        .padding(.leading,20)
    }
}

struct ControlButtonBar: View{
    @EnvironmentObject var sceneManager: SceneManager
    @Binding var showBrowse: Bool
    
    var body: some View{
        HStack{
            
            //Load Experience
            ControlButton(systemIconName: "square.and.arrow.up"){
                print("Load pressed")
                self.sceneManager.shouldLoadSceneFromFilesystem = true
            }
            .disabled(self.sceneManager.scenePersistenceData == nil)
            
            Spacer()
            
            //Browse
            ControlButton(systemIconName: "square.grid.2x2"){
                print("Browse pressed")
                self.showBrowse.toggle()
            }.sheet(isPresented: $showBrowse, content: {
                //BrowseView
                BrowseView(showBrowse: $showBrowse)
            })
            
            Spacer()
            
            //Save Experience
            ControlButton(systemIconName: "square.and.arrow.down"){
                print("Save pressed")
                self.sceneManager.shouldSaveSceneToFilesystem =  true
            }
            .disabled(!self.sceneManager.isPersistenceAvailable)
            
        }
        .frame(maxWidth: 500)
        .padding(30)
        .padding(.bottom,20)
        .background(Color.black.opacity(0.25))
    }
}

struct ControlButton: View{
    let systemIconName: String
    let action: () -> Void
    
    var body: some View{
        Button(action: {
            self.action()
        }){
            Image(systemName: systemIconName)
                .font(.system(size: 35))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
        }
        .frame(width:50, height:50)
    }
}
