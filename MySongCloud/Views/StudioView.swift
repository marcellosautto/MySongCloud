//
//  StudioView.swift
//  MySongCloud
//
//  Created by Marcello Sautto on 7/2/22.
//

import SwiftUI

struct StudioView: View {
    
    @StateObject var avAudio = AVAudio()
    
    @State private var playbackState: String = AVAudio.PlaybackState.play.state
    @State private var currentPlaybackTime: Double = 0
    
    var body: some View {
        
        ScrollView{
            VStack{
                Text("Studio")
                    .font(.title)
                RateAndPitchControlView().environmentObject(avAudio)
                
                Spacer()
               
                EqualizerView().environmentObject(avAudio)
                
                PlaybackView(playbackState: $playbackState, currentPlaybackTime: $currentPlaybackTime).environmentObject(avAudio)
                
                
            }
            .onAppear(){
                let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                    
                    if(!avAudio.isSeeking && avAudio.playerNode.isPlaying){
                        
                        let currentTime = avAudio.getTimeInSeconds()
                        
                        if(currentTime < avAudio.audioDuration){
                            currentPlaybackTime = currentTime
                        }
                        else{
                            avAudio.seekTo(time: 0)
                            playbackState = avAudio.togglePlaybackState()
                        }
                    }
                    
                })
                
            }
        }
        
}
}

struct StudioView_Previews: PreviewProvider {
    static var previews: some View {
        StudioView()
    }
}
