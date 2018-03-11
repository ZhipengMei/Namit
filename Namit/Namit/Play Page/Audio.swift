//
//  Audio.swift
//  Namit
//
//  Created by Adrian on 2/10/18.
//  Copyright © 2018 Mei. All rights reserved.
//

import UIKit
import AVFoundation

class Audio {
    
    var audioPlayer = AVAudioPlayer()

    init() {        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "time_beep", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            } catch {
                print(error)
            }
            
        } catch {
            print(error)
        }
    }
    
    func play_action() {
        audioPlayer.play()
        print("playedd")
    }
    
    func pause_action() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        } else {
            
        }
    }
    
    func restart_action() {
        if audioPlayer.isPlaying {
            audioPlayer.currentTime = 0
            audioPlayer.play()
        } else {
            audioPlayer.play()
        }
    }
    

}
