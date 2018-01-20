//
//  AppDelegate.swift
//  Namit
//
//  Created by Adrian on 1/19/18.
//  Copyright © 2018 Zhipeng. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //set coredata at first launch
        if(!UserDefaults.standard.bool(forKey: "firstlaunch1.0")){
            //Put any code here and it will be executed only once.
            
            reset_default_punishments()
            
            print("Is a first launch")
            UserDefaults.standard.set(true, forKey: "firstlaunch1.0")
            UserDefaults.standard.synchronize();
        }
        return true
    }
    
    //reset device's core data
    func reset_default_punishments() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // Punishments Entity
        let punishments_entity = NSEntityDescription.entity(forEntityName: "Punishments", in: context)
        
        let list = [
            "Exchange clothes with the person sitting on your left.",
            "Wear your swimming suit and pretend you are swimming.",
            "Lick your elbow while singing an alphabet.",
            "Let others do your hair.",
            "Go outside on the street and hold the sign “Honk if I’m cute”.",
            "Eat 1 teaspoon of mustard.",
            "Go make snacks for everybody.",
            "Build a tower as tall as you are using whatever is in the room.",
            "Wear socks on your hands, pants instead of shirt and shirt instead of pants.",
            "Gargle a song. Fill your mouth with water and try singing a song.",
            "Sit on the lap of the person on your left for entire game.",
            "Brush your teeth in front of everyone while dancing.",
            "Give piggy back rides to everybody.",
            "Imitate a monkey as best you can.",
            "Go outside and scream on top of your lungs.",
            "Act like a dog and get petted by everyone.",
            "Make up a story about the item to your right.",
            "Make a poem using the words orange and moose.",
            "Dance like crazy.",
            "Draw a mustache and keep it until the end of the game.",
            "Draw a picture using your toes.",
            "Smell everybody’s feet and find ‘the winner’.",
            "Wrap yourself in toilet paper and take a selfie.",
            "Let others paint on your face.",
            "Go and call the neighbor to play the game."]
        
        //Save Core Data
        for item in list {
            let newCard = NSManagedObject(entity: punishments_entity!, insertInto: context)
            newCard.setValue(item, forKey: "name")
            
        }
        do {
            try context.save()
            print("Punishments entity saved")
        } catch {
            print("Failed saving")
        }
        
        
        // Cards Entity
        let card_entity = NSEntityDescription.entity(forEntityName: "Cards", in: context)
        
        let wordbank:[String] = ["Fruits",
                                 "Car brands",
                                 "South-American countries",
                                 "European countries",
                                 "Asian countries",
                                 "African countries",
                                 "NBA teams",
                                 "MLB teams",
                                 "NFL teams",
                                 "Animals (A-L)",
                                 "Animals (M-Z)",
                                 "Cities in Africa",
                                 "Presidents of the United States",
                                 "Dog breeds",
                                 "Olympic sports",
                                 "Vegetables",
                                 "Fish",
                                 "Beer brands",
                                 "Vodka brands",
                                 "Tequila brands",
                                 "Soda brands",
                                 "Solar System Planets (8)",
                                 "Animated movies",
                                 "Capitals of the 50 states (State + Capital)"]
        
        //Save Core Data
        for item in wordbank {
            let newCard = NSManagedObject(entity: card_entity!, insertInto: context)
        }
        do {
            try context.save()
            print("Cards entity saved")
        } catch {
            print("Failed saving")
        }
        
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Namit")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

