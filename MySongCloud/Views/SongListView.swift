//
//  SongListView.swift
//  MySongCloud
//
//  Created by Marcello Sautto on 7/2/22.
//

import SwiftUI

struct SongListView: View {
    var body: some View {
        NavigationView{
            VStack {
                Text("My Songs")
                    .font(.title)
                
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
