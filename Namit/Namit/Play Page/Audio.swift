//
//  Audio.swift
//  Namit
//
//  Created by Adrian on 2/10/18.
//  Copyright © 2018 Mei. All rights reserved.
//

import UIKit
import AVFoundation

class Audio: NSObject, AVAudioPlayerDelegate {
    
    var audioPlayer = AVAudioPlayer()
    var isAudioEnd = false

    override init() { }
    
    func loadsound(sound: String) {
        audioPlayer = try! AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: sound, ofType: "mp3")!))
        audioPlayer.prepareToPlay()
        audioPlayer.delegate = self
        isAudioEnd = false
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSessionCategoryPlayback)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("audio ends")
        isAudioEnd = true
    }
    
    func play_action() {
        audioPlayer.play()
        isAudioEnd = false
    }
    
    func pause_action() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
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
