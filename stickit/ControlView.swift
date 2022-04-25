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
    @Binding var isControlVisible: Bool
    
    var body: some View{
        HStack{
            Spacer()
            
            ZStack{
                Color.black.opacity(0.25)
                
                Button(action:{
                    print("Control Visibility pressed")
                    self.isControlVisible.toggle()
                }){
                    Image(systemName: self.isControlVisible ? "rectangle" : "slider.horizontal.below.rectangle")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8.0)
        }
        .padding(.top,45)
        .padding(.trailing, 20)
    }
}

struct ControlButtonBar: View{
    @Binding var showBrowse: Bool
    
    var body: some View{
        HStack{
            
            //Most Recent
            ControlButton(systemIconName: "clock.fill"){
                print("MostRecentPlaced pressed")
            }
            
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
            
            //Setting
            ControlButton(systemIconName: "slider.horizontal.3"){
                print("Setting pressed")
            }
            
        }
        .frame(maxWidth: 500)
        .padding(30)
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
