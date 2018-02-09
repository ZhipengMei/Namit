////
////  Time.swift
////  My Timer
////
////  Created by Adrian on 2/3/18.
////  Copyright © 2018 Mei. All rights reserved.
////
//
//import Foundation
//import UIKit
//import CoreData
//
//class Time {
//
//    init {
//
//    }
//
//    // UI
//    var timerLabel = UILabel()
//    var pauseButton = UIButton()
//
//    // retrieve TImer's interval from CoreData
//    func getTime() -> Int {
//        let time_fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameTimer")
//        time_fetchRequest.returnsObjectsAsFaults = false
//        time_fetchRequest.fetchLimit = 1
//        do {
//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//            let result = try context.fetch(time_fetchRequest) as! [GameTimer]
//            if result.count == 1 {
//                // retrieved data
//                return Int(result[0].interval)
//            }
//        } catch {
//            print("GameTimer: Retrieve data failed.")
//        }
//
//        // default timer
//        return 5
//    }
//
//    // data
//    var seconds = getTime()
//    var timer = Timer()
//
//    // conditional boolean to pause or check current timer status
//    var isTimerRunning = false
//    var resumeTapped = false
//
//    func runTimer() {
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(Time.updateTimer)), userInfo: nil, repeats: true)
//    }
//
//    @objc func updateTimer() {
//        if seconds < 1 {
//            timer.invalidate()
//            seconds = 5
//            timerLabel.text = String(seconds)
//            runTimer()
//        } else {
//            seconds -= 1
//            timerLabel.text = String(seconds)
//        }
//    }
//
//    func pause() {
//        if self.resumeTapped == false {
//            timer.invalidate()
//            isTimerRunning = false
//            self.resumeTapped = true
//            self.pauseButton.setTitle("RESUME",for: .normal)
//        } else {
//            runTimer()
//            self.resumeTapped = false
//            isTimerRunning = true
//            self.pauseButton.setTitle("PAUSE",for: .normal)
//        }
//    }
//
//}


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
    
    init() {
        seconds = getTime()
    }
    
    // UI
    var timerLabel = UILabel()
    var pauseButton = UIButton()
    
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

