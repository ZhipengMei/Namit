//
//  CardVC.swift
//  NameIt
//
//  Created by Adrian on 12/27/17.
//  Copyright © 2017 zhipeng. All rights reserved.
//

import UIKit
import CoreData

class CardVC: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var card_label: UILabel!
    @IBOutlet weak var next_button: UIButton!
    @IBOutlet weak var punishment_button: UIButton!
    @IBOutlet var card_vc_view: UIView!
    @IBOutlet weak var cancel_button: FlatButton!
    
    public var context: NSManagedObjectContext!
    var previous_index = 0
    
    // MARK: -
    //default for NSFetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Save Note")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        //change UIview background
        let bg_color = UIColor(red: 19/255, green: 38/255, blue: 51/255, alpha: 1.0)
        self.card_vc_view.backgroundColor = bg_color

//        (fetchedResultsController.fetchedObjects).shuffle()
        let indexPath = IndexPath(row: previous_index, section: 0)
        let card = fetchedResultsController.object(at: indexPath) as! Cards
        card_label.text = card.name
//        card_label.text = (fetchedResultsController[previous_index] as! String //display text in card
        card_label.textColor = UIColor.white
        
        self.card_label.alpha = 0
        self.next_button.alpha = 0
        self.punishment_button.alpha = 0
        
        self.next_button.layer.cornerRadius = 10
        self.next_button.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 0.5)
        
        self.punishment_button.layer.cornerRadius = 10
        self.punishment_button.backgroundColor = UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 0.5)

        self.cardView.layer.cornerRadius = 10
        self.cardView.backgroundColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.00)
        
        //modify cancel button
        let color = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1.0)
        cancel_button.setTitleColor(UIColor.white, for: .normal)
        cancel_button.color = color
        cancel_button.highlightedColor = color
        cancel_button.selectedColor = .blue
        cancel_button.cornerRadius = 8
    }
    
    var tap_bool = false
    //tap action to display message content
    @IBAction func tapAction(_ sender: Any) {
        
        //force animation to run once
        if tap_bool == false {
            UIView.transition(with: cardView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            tap_bool = true
        }
        
        //fade in animation
        UIView.animate(withDuration: 1.5,
                       delay: 0.5,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.5,
                       options: [], animations: {
                                    self.card_label.alpha = 1 },
                       completion: nil)

        UIView.animate(withDuration: 2.0,
                       delay: 0.5,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.5,
                       options: [], animations: {
                        self.next_button.alpha = 1
                        self.punishment_button.alpha = 1 },
                       completion: nil)
    }
    
    //display a new card
    @IBAction func show_next_card(_ sender: Any) {
        previous_index += 1
        if previous_index < (fetchedResultsController.fetchedObjects?.count)! {
            let indexPath = IndexPath(row: previous_index, section: 0)
            let card = fetchedResultsController.object(at: indexPath) as! Cards
            card_label.text = card.name
//            card_label.text = fetchedResultsController.fetchedObjects?[previous_index] as? String //display text in card
        } else {
//            fetchedResultsController.shuffle()
            previous_index = -1
//            print(previous_index)
//            print(fetchedResultsController)
        }
        
        //flip UIView animation
        UIView.transition(with: cardView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
}

/**
 Extend array to enable random shuffling
 */
extension Array {
    /**
     Randomizes the order of an array's elements
     */
    mutating func shuffle() {
        for _ in 0..<count {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
