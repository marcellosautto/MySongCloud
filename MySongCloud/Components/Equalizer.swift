//
//  Equalizer.swift
//  MySongCloud
//
//  Created by Marcello Sautto on 8/9/22.
//

import SwiftUI

struct EqualizerView: View {
    
    @State private var bassFreq: Float = 0
    @State private var midrangeFreq: Float = 0
    @State private var trebleFreq: Float = 0
    
    @EnvironmentObject var avAudio: AVAudio
    
    var body: some View {
        VStack{
            
            HStack {
                Text("Bass").bold()
                Spacer()
            }.padding(.leading)
            
            Slider(
                value: $bassFreq,
                in: -5...5,
                step: 1
            ) {
            } minimumValueLabel: {
                Text("-5")
            } maximumValueLabel: {
                Text("+5")
            } onEditingChanged: { seeking in
                avAudio.isSeeking = seeking
                avAudio.setBass(to: bassFreq)
            }.padding()
            Text("\(bassFreq > 0 ? "+" : "")\(bassFreq, specifier: "%.0f")")
            
            HStack {
                Text("Midrange").bold()
                Spacer()
            }.padding(.leading)
            
            Slider(
                value: $midrangeFreq,
                in: -5...5,
                step: 1
            ) {
            } minimumValueLabel: {
                Text("-5")
            } maximumValueLabel: {
                Text("+5")
            } onEditingChanged: { seeking in
                avAudio.isSeeking = seeking
                avAudio.setMiddle(to: midrangeFreq)
            }.padding()
            Text("\(midrangeFreq > 0 ? "+" : "")\(midrangeFreq, specifier: "%.0f")")
            
            HStack {
                Text("Treble").bold()
                Spacer()
            }.padding(.leading)
            
            Slider(
                value: $trebleFreq,
                in: -5...5,
                step: 1
            ) {
            } minimumValueLabel: {
                Text("-5")
            } maximumValueLabel: {
                Text("+5")
            } onEditingChanged: { seeking in
                avAudio.isSeeking = seeking
                avAudio.setTreble(to: trebleFreq)
            }.padding()
            Text("\(trebleFreq > 0 ? "+" : "")\(trebleFreq, specifier: "%.0f")")
        }
    }
}

struct EqualizerView_Previews: PreviewProvider {
    static var previews: some View {
        EqualizerView().environmentObject(AVAudio())
    }
}
