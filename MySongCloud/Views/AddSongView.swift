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
                            HStack {
                                Text(.init("[\(song.title)](\(song.url))"))
                                
                            }
                            .frame(width: CGFloat(song.thumbnail_width)*0.60)
                            .padding()
                            .background(Color(red: 0.52, green: 0.21, blue: 0.47))
                            .accentColor(.white)
                            .cornerRadius(10.0)
                            
                                
                                
                            //Link("\(song.title)", destination: song.url)
                            AsyncImage(url: song.thumbnail.absoluteURL, scale: 1.5)
                            Button("Download", action: {/*call api for downloading youtube videos as mp3s*/})
                                .padding()
                                .background(Color(red: 0.18, green: 0.58, blue: 0.82))
                                .cornerRadius(6.0)
                                .foregroundColor(Color.white)
                            
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
