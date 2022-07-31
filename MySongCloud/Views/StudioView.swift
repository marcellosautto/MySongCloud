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
    @State private var currentPlaybackRate: Float = 1
    @State private var currentPitch: Float = 0
    
    var body: some View {
        VStack{
            Text("Studio")
                .font(.title)
            VStack {

                HStack {
                    Text("Rate").bold()
                    Spacer()
                }.padding(.leading)
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
                }.padding()
                Text("\(currentPlaybackRate, specifier: "%.1f")")
                
                
                
                HStack {
                    Text("Pitch").bold()
                    Spacer()
                }.padding(.leading)
                
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
                }.padding()
                Text("\(currentPitch > 0 ? "+" : "")\(currentPitch, specifier: "%.0f")")
                
                
            }.padding(.top)
            
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
                Text("Speed")
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

struct StudioView_Previews: PreviewProvider {
    static var previews: some View {
        StudioView()
    }
}
