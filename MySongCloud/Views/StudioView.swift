//
//  StudioView.swift
//  MySongCloud
//
//  Created by Marcello Sautto on 7/2/22.
//

import SwiftUI

struct StudioView: View {
    
    @StateObject var avAudio = AVAudio()
    @State private var playbackState: AVAudio.PlaybackState = .play
    @State private var currentPlaybackTime: Double = 0
    
    var body: some View {
        VStack{
            Text("Studio")
                .font(.title)
            
            HStack{
                Button(action: {playbackState = avAudio.togglePlaybackState()}){
                    Image(systemName: "\(playbackState)")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .aspectRatio(contentMode: .fit)
                }
                
                
//                Button(action: {avAudio.stop()}){
//                    Image(systemName: "stop")
//                        .resizable()
//                        .frame(width: 50, height: 50)
//                        .aspectRatio(contentMode: .fit)
//                }
            }
            
            VStack {
                Slider(
                    value: $currentPlaybackTime,
                    in: 0...avAudio.audioDuration,
                    step: 1
                ) {
                    Text("Speed")
                } minimumValueLabel: {
                    Text("\(avAudio.formattedTime(time: currentPlaybackTime))")
                } maximumValueLabel: {
                    Text("\(avAudio.audioDurationString)")
                } onEditingChanged: { seeking in
                    avAudio.isSeeking = seeking
                }
                //Text("\(currentPlaybackTime)")
                    
                }
            
        }
        .onAppear(){
            
        }
    }
}

struct StudioView_Previews: PreviewProvider {
    static var previews: some View {
        StudioView()
    }
}
