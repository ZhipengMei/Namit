//
//  CardVC.swift
//  NameIt
//
//  Created by Adrian on 12/27/17.
//  Copyright © 2017 zhipeng. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

class CardVC: UIViewController, NSFetchedResultsControllerDelegate, GADBannerViewDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var card_label: UILabel!
    @IBOutlet weak var punishment_button: UIButton!
    @IBOutlet var card_vc_view: UIView!
    @IBOutlet weak var cancel_button: FlatButton!
    
    public var context: NSManagedObjectContext!
    var previous_index = 0
    var bannerView: GADBannerView!
    
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
        
        //Google Ads banner view
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.frame = CGRect(x: 0.0,
                                  y: view.frame.size.height - bannerView.frame.height, //bottom of the view
            width: bannerView.frame.width,
            height: bannerView.frame.height)
        self.view.addSubview(bannerView)
        //        bannerView.adUnitID = "ca-app-pub-5562078941559997/8772933204"
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        let requestAd: GADRequest = GADRequest()
        requestAd.testDevices = [kGADSimulatorID]
        bannerView.load(requestAd)

        //show a card
        show_next_card()
//        fadein_effect()
    }
    
    var tap_bool = false
    //tap action to display message content
    @IBAction func tapAction(_ sender: Any) {
        
        show_next_card()
        
        //force animation to run once
        if tap_bool == false {
            UIView.transition(with: cardView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            tap_bool = true
        }
    
    }
    
    //display and randomized cards order
    var cardCount = 0
    var cardObj: [Cards] = []
    func show_next_card() {
        if cardCount > 0 && cardCount < (fetchedResultsController.fetchedObjects?.count)! {
//            let indexPath = IndexPath(row: cardCount, section: 0)
            card_label.text = cardObj[cardCount].name!
            cardCount += 1
        } else if cardCount == 0 || cardCount >= (fetchedResultsController.fetchedObjects?.count)! {
            cardObj = fetchedResultsController.fetchedObjects as! [Cards]
            cardObj.shuffle()
            cardCount = 1
            show_next_card()
        }
        
        //flip UIView animation
        UIView.transition(with: cardView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    @IBAction func cancel_button_cation(_ sender: Any) {
        cardCount = 0
        dismiss(animated: true, completion: nil)
    }
    
    func fadein_effect() {
        self.card_label.alpha = 0
        self.punishment_button.alpha = 0
        
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
                        self.punishment_button.alpha = 1 },
                       completion: nil)
    }
    
}

/**
 Extend array to enable random shuffling
 */
extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
