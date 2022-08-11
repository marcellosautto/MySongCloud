//
//  AudioEngineViewModel.swift
//  MySongCloud
//
//  Created by Marcello Sautto on 7/30/22.
//

import Foundation
import AVFoundation

class AVAudio: ObservableObject{
    
    let engine: AVAudioEngine
    let playerNode: AVAudioPlayerNode
    var audioFile: AVAudioFile
    var audioBuffer: AVAudioPCMBuffer!
    var equalizer: AVAudioUnitEQ!
    var rateAndPitchNode: AVAudioUnitTimePitch!
    var currentPlaybackTime: Double
    var audioDuration: Double
    var audioDurationString: String
    
    var isPlaying: Bool = false
    var isSeeking: Bool = false
    
    init(engine: AVAudioEngine = AVAudioEngine(), playerNode:AVAudioPlayerNode = AVAudioPlayerNode(), audioFile: AVAudioFile = AVAudioFile(), pitchNode: AVAudioUnitTimePitch = AVAudioUnitTimePitch()){
        
        self.engine = engine
        self.playerNode = playerNode
        self.audioFile = audioFile
        self.rateAndPitchNode = pitchNode
        self.currentPlaybackTime = 0
        self.audioDuration = 0
        self.audioDurationString = "00:00"
        
        cfgAudio()
        
        
    }
    
    private func cfgAudio(){
        
        do{
            guard let url = Bundle.main.url(forResource: "song", withExtension: "mp3") else {return}
            self.audioFile = try AVAudioFile(forReading: url)
        }catch{
            print("Error retrieving audio file: \(error.localizedDescription)")
        }
        
        
        let audioFileFormat = audioFile.processingFormat
        
        cfgBuffer(with: audioFileFormat)
        cfgEqualizer()
        cfgEngine(with: audioFileFormat)
    }
    
    func cfgEqualizer(){
        equalizer = AVAudioUnitEQ(numberOfBands: 3)
        let bands = equalizer.bands
        let freqs = [100, 1000, 10000]
        
        for i in 0...(bands.count - 1) {
            bands[i].frequency  = Float(freqs[i])
            bands[i].bypass     = false
            bands[i].filterType = .parametric
        }

        bands[0].gain = -10.0
        bands[0].filterType = .lowShelf
        bands[1].gain = -10.0
        bands[1].filterType = .lowShelf
        bands[2].gain = 10.0
        bands[2].filterType = .highShelf
        
    }
    
    func cfgBuffer(with format: AVAudioFormat){
        
        do{
            let audioFrameCount = UInt32(audioFile.length)
            audioBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: audioFrameCount)
            try audioFile.read(into: audioBuffer)

        }catch{
            print("Error initializing audio buffer: \(error.localizedDescription)")
        }
        
    }
    
    func cfgEngine(with format: AVAudioFormat){
        
        engine.attach(playerNode)
        engine.attach(rateAndPitchNode)
        engine.attach(equalizer)
        
        engine.connect(playerNode, to: rateAndPitchNode, format: format)
        engine.connect(rateAndPitchNode, to: equalizer, format: format)
        engine.connect(equalizer, to: engine.outputNode, format: format)
        
        engine.prepare()
        
        do{
            audioDuration = calcSongDuration()
            audioDurationString = formattedTime(time: audioDuration)
            try engine.start()
            playerNode.scheduleBuffer(audioBuffer, at: nil, completionHandler: nil)
            
        }catch{
            print("Error starting engine: \(error.localizedDescription)")
        }
    }
    
    func calcSongDuration() -> Double{
        
        let frameLength = audioFile.length
        let sampleRate = audioFile.processingFormat.sampleRate
        
        return Double(frameLength) / sampleRate
    }
    
    func getTimeInSeconds() -> TimeInterval{
        
        if let nodeTime = playerNode.lastRenderTime,let playerTime = playerNode.playerTime(forNodeTime: nodeTime) {
            return currentPlaybackTime+(Double(playerTime.sampleTime) / playerTime.sampleRate)
        }
        return 0
    }
    
    func formattedTime(time: Double) -> String{
        
        let timeInSeconds = time
        
        let minutes = timeInSeconds / 60
        let seconds = timeInSeconds.truncatingRemainder(dividingBy: 60.0)
        
        let minutesFormatted = String(format: "%02d", Int(minutes))
        let secondsFormatted = String(format: "%02d", Int(seconds))
        
        return "\(minutesFormatted):\(secondsFormatted)"
    }
    
    func togglePlaybackState() -> String{
        
        self.isPlaying.toggle()
        
        if(playerNode.isPlaying){
            
            playerNode.pause()
            return PlaybackState.play.state
        }
        else{
            
            playerNode.play()
            return PlaybackState.pause.state
        }
        
    }
    
    func stop(){
        playerNode.stop()
    }
    
    func seekTo(time: Double){
        
        var seekFrame = AVAudioFramePosition(time*audioFile.processingFormat.sampleRate)
        
        let wasPlaying = playerNode.isPlaying
        
        playerNode.stop()
        
       
        currentPlaybackTime = (Double(seekFrame) / Double(audioFile.length))*audioDuration

        if(seekFrame < 0 || seekFrame >= audioFile.length){
            seekFrame = 0
        }
        
        let frameCount = AVAudioFrameCount(audioFile.length - seekFrame)
        
        
          // 3
          playerNode.scheduleSegment(
            audioFile,
            startingFrame: seekFrame,
            frameCount: frameCount,
            at: nil
          ) {
            //self.needsFileScheduled = true
          }

          // 4
          if wasPlaying {
              playerNode.play()
          }
        
    }
    
    func setRate(to rate: Float){
        rateAndPitchNode.rate = rate

    }
    
    func setPitch(to pitch: Float){
        rateAndPitchNode.pitch = pitch
    }
    
    func setBass(to freq: Float){
        
        var hz = freq
        
        switch hz {
            
        case -5:
            hz = 200
        case -4:
            hz = 186
        case -3:
            hz = 172
        case -2:
            hz = 158
        case -1:
            hz = 144
        case 0:
            hz = 116
        case 1:
            hz = 102
        case 2:
            hz = 88
        case 3:
            hz = 74
        case 4:
            hz = 60
        case 5:
            hz = 46
        default:
            hz = 116
        }
        equalizer.bands[0].frequency = hz
    }
    
    func setMiddle(to freq: Float){
        
        var hz = freq
        
        switch hz {
            
        case -5:
            hz = 2000
        case -4:
            hz = 1860
        case -3:
            hz = 1720
        case -2:
            hz = 1580
        case -1:
            hz = 1440
        case 0:
            hz = 1160
        case 1:
            hz = 1020
        case 2:
            hz = 880
        case 3:
            hz = 740
        case 4:
            hz = 600
        case 5:
            hz = 460
        default:
            hz = 1160
        }
        
        equalizer.bands[1].frequency = freq
    }
    
    func setTreble(to freq: Float){
        
        var hz = freq
        
        switch hz {
            
        case -5:
            hz = 10000
        case -4:
            hz = 9500
        case -3:
            hz = 9000
        case -2:
            hz = 8500
        case -1:
            hz = 8000
        case 0:
            hz = 7500
        case 1:
            hz = 7000
        case 2:
            hz = 6500
        case 3:
            hz = 6000
        case 4:
            hz = 5500
        case 5:
            hz = 5000
        default:
            hz = 7500
        }
        
        equalizer.bands[2].frequency = freq
    }
}

extension AVAudio{
    enum PlaybackState{
        case play, pause
        
        var state: String{
            
            switch self{
            case .play:
                return "play.circle"
            case .pause:
                return "pause.circle"
            }
        }
    }
    
    
    
    
}
