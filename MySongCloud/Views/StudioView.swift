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
    @State private var currentPlaybackRate: Float = 1
    @State private var currentPitch: Float = 0
    
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
                    avAudio.seekTo(time: currentPlaybackTime)
                }
                //Text("\(currentPlaybackTime)")
                
                Slider(
                    value: $currentPlaybackRate,
                    in: 0.5...2.0,
                    step: 0.1
                ) {
                    Text("Rate")
                } minimumValueLabel: {
                    Text("0.5")
                } maximumValueLabel: {
                    Text("2.0")
                } onEditingChanged: { seeking in
                    avAudio.isSeeking = seeking
                    avAudio.setRate(to: currentPlaybackRate)
                }
                Text("\(currentPlaybackRate, specifier: "%.1f")")
                
                Slider(
                    value: $currentPitch,
                    in: -12...12,
                    step: 1
                ) {
                    Text("Pitch")
                } minimumValueLabel: {
                    Text("-12")
                } maximumValueLabel: {
                    Text("12")
                } onEditingChanged: { seeking in
                    avAudio.isSeeking = seeking
                    avAudio.setPitch(to: currentPitch*100)
                }
                Text("\(currentPitch, specifier: "%.0f")")
                
            }
            
        }
        .onAppear(){
            let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                
                if(!avAudio.isSeeking){
                    currentPlaybackTime = avAudio.getTimeInSeconds()
                }
                
            })
            
        }
    }
}

struct StudioView_Previews: PreviewProvider {
    static var previews: some View {
        StudioView()
    }
}
