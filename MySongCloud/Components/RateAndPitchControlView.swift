//
//  RateAndPitchControlView.swift
//  MySongCloud
//
//  Created by Marcello Sautto on 8/9/22.
//

import SwiftUI

struct RateAndPitchControlView: View {
    
    @EnvironmentObject var avAudio: AVAudio
    
    @State var currentPlaybackRate: Float = 1.0
    @State var currentPitch: Float = 0.0
    
    var body: some View {
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
    }
}

struct RateAndPitchControlView_Previews: PreviewProvider {
    static var previews: some View {
        RateAndPitchControlView()
            .environmentObject(AVAudio())
    }
}
