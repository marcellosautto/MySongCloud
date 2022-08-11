//
//  PlaybackView.swift
//  MySongCloud
//
//  Created by Marcello Sautto on 8/9/22.
//

import SwiftUI

struct PlaybackView: View {
    
    @Binding var playbackState: String
    @Binding var currentPlaybackTime: Double
    
    @EnvironmentObject var avAudio: AVAudio
    
    var body: some View {
        VStack {
            Spacer()
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
        
        
        
        Slider(
            value: $currentPlaybackTime,
            in: 0...avAudio.audioDuration,
            step: 1
        ) {
            Text("Playback Time")
        } minimumValueLabel: {
            Text("\(avAudio.formattedTime(time: currentPlaybackTime))")
        } maximumValueLabel: {
            Text("\(avAudio.audioDurationString)")
        } onEditingChanged: { seeking in
            avAudio.isSeeking = seeking
            avAudio.seekTo(time: currentPlaybackTime)
        }.padding()
        //Text("\(currentPlaybackTime)")
        
        Spacer()
        }
    }
}

struct PlaybackView_Previews: PreviewProvider {
    static var previews: some View {
        PlaybackView(playbackState: .constant(AVAudio.PlaybackState.play.state), currentPlaybackTime: .constant(0.0)).environmentObject(AVAudio())
    }
}
