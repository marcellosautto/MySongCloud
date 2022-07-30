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
    var currentPlaybackTime: Double
    //var currentPlaybackTimeString: String
    var audioDuration: Double
    var audioDurationString: String
    
    var isPlaying: Bool = false
    var isSeeking: Bool?
    
    init(engine: AVAudioEngine = AVAudioEngine(), playerNode:AVAudioPlayerNode = AVAudioPlayerNode(), audioFile: AVAudioFile = AVAudioFile()){
        
        self.engine = engine
        self.playerNode = playerNode
        self.audioFile = audioFile
        self.currentPlaybackTime = 0
        //self.currentPlaybackTimeString = "00:00"
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
        cfgEngine(with: audioFileFormat)
    }
    
    func cfgBuffer(with format: AVAudioFormat){
        
        do{
            let audioFrameCount = UInt32(audioFile.length)
            audioBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: audioFrameCount)
            try audioFile.read(into: audioBuffer)
            audioDuration = calcSongDuration()
        }catch{
            print("Error initializing audio buffer: \(error.localizedDescription)")
        }
        
    }
    
    func cfgEngine(with format: AVAudioFormat){
        
        engine.attach(playerNode)
        
        engine.connect(playerNode, to: engine.outputNode, format: format)
        
        engine.prepare()
        
        do{
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
    
    func getTimeInSeconds()->TimeInterval{
        
        if let nodeTime = playerNode.lastRenderTime,let playerTime = playerNode.playerTime(forNodeTime: nodeTime) {
            return Double(playerTime.sampleTime) / playerTime.sampleRate
        }
        return 0
    }
    
    func formattedTime(time: Double) -> String{
        
        let timeInSeconds = getTimeInSeconds()
        
        let minutes = timeInSeconds / 60
        let seconds = timeInSeconds.truncatingRemainder(dividingBy: 60.0)
        
        let minutesFormatted = String(format: "%02d", Int(minutes))
        let secondsFormatted = String(format: "%02d", Int(seconds))
        
        return "\(minutesFormatted):\(secondsFormatted)"
    }
    
    func togglePlaybackState() -> PlaybackState{
        
        self.isPlaying.toggle()
        
        if(playerNode.isPlaying){
            
            playerNode.pause()
            return PlaybackState.play
        }
        else{
            
            playerNode.play()
            return PlaybackState.pause
        }
        
    }
    
    func stop(){
        playerNode.stop()
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
