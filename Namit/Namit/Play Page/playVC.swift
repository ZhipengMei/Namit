//
//  playVC.swift
//  Namit
//
//  Created by Adrian on 2/3/18.
//  Copyright © 2018 Mei. All rights reserved.
//

import UIKit
import CoreData

class playVC: UIViewController, NSFetchedResultsControllerDelegate {

    // buttons
    @IBOutlet weak var exit_button: UIButton!
    @IBOutlet weak var pause_button: UIButton!
    @IBOutlet weak var punishment_button: UIButton!
    
    // labels
    @IBOutlet weak var exit_label: UILabel!
    @IBOutlet weak var pause_label: UILabel!
    @IBOutlet weak var timer_label: UILabel!
    @IBOutlet weak var card_label: UILabel!
    
    // view
    @IBOutlet weak var card_view: UIView!
    
    // timer class
    let time = Time()
    
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
            // fetching coreData
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Save Note")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }

        // exit button
        exit_button.backgroundColor = UIColor.red
        exit_button.layer.cornerRadius = self.exit_button.bounds.width * 0.5
        
        // pause button
        pause_button.backgroundColor = UIColor.red
        pause_button.layer.cornerRadius = self.pause_button.bounds.width * 0.5
        pause_button.titleLabel?.font =  UIFont(name: "helvetica neue", size: 10)
        
        // punishment button
        punishment_button.backgroundColor = UIColor.red
        punishment_button.layer.cornerRadius = self.punishment_button.bounds.height / 2
        punishment_button.setTitleColor(UIColor.white, for: .normal)
        // font & size
        punishment_button.titleLabel?.font =  UIFont(name: "helvetica neue", size: 15)
        // string kerning
        let attributedString = NSMutableAttributedString(string: "PUNISHMENT")
        attributedString.addAttribute(NSAttributedStringKey.kern, value: 15, range: NSRange(location: 0, length: attributedString.length - 1))
        punishment_button.titleLabel?.attributedText = attributedString
        
        // exit label
        exit_label.textColor = UIColor.white
        
        // pause label
        pause_label.textColor = UIColor.white
        
        // timer label
        timer_label.textColor = UIColor.white
        timer_label.layer.cornerRadius = self.timer_label.bounds.width * 0.5
        timer_label.layer.borderWidth = 2.0
        timer_label.layer.borderColor = (UIColor.white).cgColor
        timer_label.backgroundColor = UIColor.clear
        timer_label.font =  UIFont(name: "helvetica neue", size: 40)
        
        // card label
        card_label.textAlignment = .center
        card_label.textColor = .black
        card_label.numberOfLines = 0
        // display the first card
        card_label.text = randomTask().name!
        
        // card_view
        card_view.backgroundColor = UIColor.white
        card_view.layer.cornerRadius = 10
        
        // view
        self.view.backgroundColor = UIColor.black
        
        // setup timer
        time.timerLabel = timer_label
        time.pauseButton = pause_button
        time.runTimer()
        
        // ================= Tap Gesture ==================================================
        // Add tap gesture to card_view
        // The flip_card: method will be fliping the card_view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(flip_card(sender:)))
        
        // Optionally set the number of required taps, e.g., 2 for a double click
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        card_view.isUserInteractionEnabled = true
        card_view.addGestureRecognizer(tapGestureRecognizer)
        // =================================================================================
        

        
    }
    
    // dismiss view
    @IBAction func exit_action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // pause timer
    @IBAction func pause_action(_ sender: Any) {
        time.pause()
    }
    
}


// Helper func
extension playVC {
    // randomize the order of the fetchedObjects
    func randomTask() -> Cards {
        let count = UInt32(fetchedResultsController.fetchedObjects!.count)
        let index = Int(arc4random_uniform(count))
        let results = fetchedResultsController.fetchedObjects![index] as! Cards
        return results
    }
    
    // tap gesture action method
    @objc func flip_card(sender: UITapGestureRecognizer) {
        
        // display a new card
        card_label.text = randomTask().name!
        
        //flip UIView animation
        UIView.transition(with: card_view, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
}

