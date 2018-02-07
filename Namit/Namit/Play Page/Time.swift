//
//  Time.swift
//  My Timer
//
//  Created by Adrian on 2/3/18.
//  Copyright © 2018 Mei. All rights reserved.
//

import Foundation
import UIKit

class Time {
    
    // UI
    var timerLabel = UILabel()
    var pauseButton = UIButton()
    
    // data
    var seconds = 5
    var timer = Timer()
    
    // conditional boolean to pause or check current timer status
    var isTimerRunning = false
    var resumeTapped = false
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(Time.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            seconds = 5
            timerLabel.text = String(seconds)
            runTimer()
        } else {
            seconds -= 1
            timerLabel.text = String(seconds)
        }
    }
    
    func pause() {
        if self.resumeTapped == false {
            timer.invalidate()
            isTimerRunning = false
            self.resumeTapped = true
            self.pauseButton.setTitle("RESUME",for: .normal)
        } else {
            runTimer()
            self.resumeTapped = false
            isTimerRunning = true
            self.pauseButton.setTitle("PAUSE",for: .normal)
        }
    }
    
}
