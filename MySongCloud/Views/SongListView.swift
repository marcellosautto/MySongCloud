//
//  SongListView.swift
//  MySongCloud
//
//  Created by Marcello Sautto on 7/2/22.
//

import SwiftUI

struct SongListView: View {
    
    //var sampleSearch = "industry baby"
    @StateObject var songListVM = SongListViewModel()
    @State var isPresentingAddSongView: Bool = false
    
    var body: some View {
        //NavigationView{
            VStack {
                Text("My Songs")
                    .font(.title)
                
                Button("Search", action: {isPresentingAddSongView = true})
                Spacer()
            }
            .sheet(isPresented: $isPresentingAddSongView){
                NavigationView{
                    AddSongView()
                        .environmentObject(songListVM)
                        .toolbar{
                            ToolbarItem(placement: .cancellationAction){
                                Button(action: {
                                    isPresentingAddSongView = false
                                    songListVM.response = nil
                                }, label: {
                                    Text("Back")
                                })
                            }
                            
                        }
                }
                
                
            }
        //}

        
    }
}

struct SongListView_Previews: PreviewProvider {
    static var previews: some View {
        SongListView()
    }
}
