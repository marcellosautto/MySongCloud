//
//  AddSongView.swift
//  MySongCloud
//
//  Created by Marcello Sautto on 8/2/22.
//

import SwiftUI

struct AddSongView: View {
    @EnvironmentObject var songListVM: SongListViewModel
    @State private var search: String = ""
    @State private var searchSuccessful = false
    
    var body: some View {
        VStack{
            HStack{
                TextField("Enter song...", text: $search)
                    .padding(5)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                    .cornerRadius(3.0)
                
                Button("Search", action: {
                    songListVM.getSongs(search: search)
                })
            }
            .padding()
            
            
            if songListVM.response != nil{
                VStack(spacing: 20){
                    ScrollView{
                        ForEach(songListVM.response.songs){ song in
                            Link("\(song.title)", destination: song.url)
                            AsyncImage(url: song.thumbnail.absoluteURL, scale: 1.5)
                            Button("Download", action: {/*call api for downloading youtube videos as mp3s*/})
                            
                            Divider().background(Color.black)
                        }

                    }
                    
                }
            }
            Spacer()
        }
        
        
    }
}

struct AddSongView_Previews: PreviewProvider {
    static var previews: some View {
        AddSongView()
            .environmentObject(SongListViewModel())
    }
}
