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
    var long_sound = Audio()
    
    // UI
    var timerLabel = UILabel()
    var pauseButton = UIButton()
    var punishmentView = UIView()
    
    //condition
    var isPlaySound: Bool = true
    
    init() {
        seconds = self.getTime()
        beep_sound.loadsound(sound: "short")
        long_sound.loadsound(sound: "long")
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
                isPlaySound = result[0].soundOn
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
        //do not remove this, change label alpha value back to normal
        timerLabel.textColor = UIColor.white.withAlphaComponent(1.0)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(Time.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds >= 1 {
            seconds -= 1
            if seconds < 4 && seconds > 0 && isPlaySound == true{
                beep_sound.play_action()
            }
            timerLabel.text = String(seconds)
        } else {
            if isPlaySound == true && seconds == 0{
                //long_sound.play_action()
                if long_sound.isAudioEnd == true {
                    print("fUIView.animate(withDuration: 0.2, animations: {UIView.animate(withDuration: 0.2, animations: {UIView.animate(withDuration: 0.2, animations: {UIView.animate(withDuration: 0.2, animations: {UIView.animate(withDuration: 0.2, animations: {UIView.animate(withDuration: 0.2, animations: {UIView.animate(withDuration: 0.2, animations: {UIView.animate(withDuration: 0.2, animations: {")
                }
            }
            self.interrupt()
            UIView.animate(withDuration: 0.2, animations: {
                self.punishmentView.alpha = 1
            })
        }
    }
    
    func interrupt(){
        timer.invalidate()
    }
    
    func pause() {
        if self.resumeTapped == false {
            timer.invalidate()
            isTimerRunning = false
            self.resumeTapped = true
            pauseButton.setImage(UIImage(named: "resume_button")?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if self.resumeTapped == true {
            self.resumeTapped = false
            isTimerRunning = true
            pauseButton.setImage(UIImage(named: "pause_button")?.withRenderingMode(.alwaysOriginal), for: .normal)
            runTimer()
        }
    }
    
    func reset() {
        timer.invalidate()
        seconds = self.getTime()
        timerLabel.text = String(seconds)
        runTimer()
    }
    
    func stop() {
        timer.invalidate()
        timer.invalidate()
        timer.invalidate()
        timerLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        seconds = self.getTime()
        timerLabel.text = String(seconds)
    }
    
}

