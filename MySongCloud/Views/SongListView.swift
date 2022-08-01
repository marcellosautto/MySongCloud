//
//  SongListView.swift
//  MySongCloud
//
//  Created by Marcello Sautto on 7/2/22.
//

import SwiftUI

struct SongListView: View {
    
    //var sampleSearch = "industry baby"
    @StateObject var SongListVM = SongListViewModel()
    
    var body: some View {
        NavigationView{
            VStack {
                Text("My Songs")
                    .font(.title)
                
                Button(action: {}){
                    Text("Get Songs")
                }
                
                Spacer()
            }
            .toolbar{
                ToolbarItem(placement: .confirmationAction){
                    Button(action: {}, label: {
                        Label("", systemImage: "plus")
                    })
                }
            }
        }
        
    }
}

struct SongListView_Previews: PreviewProvider {
    static var previews: some View {
        SongListView()
    }
}
