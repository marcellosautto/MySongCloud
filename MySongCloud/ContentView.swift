//
//  ContentView.swift
//  MySongCloud
//
//  Created by Marcello Sautto on 7/2/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        TabView{
            HomeView()
                .tabItem{
                    Label("Home", systemImage: "house")
                }
            
            StudioView()
                .tabItem{
                    Label("Studio", systemImage: "music.note.tv")
                }
            
            SongListView()
                .tabItem{
                    Label("My Songs", systemImage: "music.note.list")
                }
            

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
