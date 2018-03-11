//
//  Time.swift
//  My Timer
//
//  Created by Adrian on 2/3/18.
//  Copyright © 2018 Mei. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Time {
    
    // data
    var seconds = 10
    var timer = Timer()
    var beep_sound = Audio()
    
    // UI
    var timerLabel = UILabel()
    var pauseButton = UIButton()
    
    init() {
        seconds = self.getTime()
    }
    
    // retrieve TImer's interval from CoreData
    func getTime() -> Int {
        let time_fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameTimer")
        time_fetchRequest.returnsObjectsAsFaults = false
        time_fetchRequest.fetchLimit = 1
        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let result = try context.fetch(time_fetchRequest) as! [GameTimer]
            if result.count == 1 {
                // retrieved data
                return Int(result[0].interval)
            }
        } catch {
            print("GameTimer: Retrieve data failed.")
        }
        // default time
        return 5
    }

    
    // conditional boolean to pause or check current timer status
    var isTimerRunning = false
    var resumeTapped = false
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(Time.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            seconds = self.getTime()
            timerLabel.text = String(seconds)
            runTimer()
        } else {
            seconds -= 1
            if seconds < self.getTime() {
                //TODO, resume sounds 
                //beep_sound.play_action()
            }
            timerLabel.text = String(seconds)
        }
    }

    @objc func someMethod() { // name this properly!
        print("called someMethod")
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
    
    func reset() {
        timer.invalidate()
        seconds = self.getTime()
        timerLabel.text = String(seconds)
        runTimer()
    }
    
    func stop() {
        beep_sound.pause_action()
        timer.invalidate()
    }
    
}

