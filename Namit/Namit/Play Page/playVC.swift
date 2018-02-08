//
//  playVC.swift
//  Namit
//
//  Created by Adrian on 2/3/18.
//  Copyright © 2018 Mei. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

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
    
    // Native Express Ad View
    @IBOutlet weak var nativeExpressAdView: GADNativeExpressAdView!
    
    // Interstitial_STEP 1: Create an interstitial ad object
    var interstitial: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()
                
        // fetching coreData
        do {
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
        

        // ================= Interstitial Ads ==================================================
        // Interstitial_STEP 2:
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let interstitial_request = GADRequest()
        interstitial_request.testDevices = [ kGADSimulatorID ]
        interstitial.load(interstitial_request)
        
        // Interstitial_STEP 3: Show the ad
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
        
        // Interstitial_STEP 4: Reload
        interstitial = createAndLoadInterstitial()
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
    
    // randomize the order of the fetchedObjects
    func randomTask() -> Cards {
        let count = UInt32(fetchedResultsController.fetchedObjects!.count)
        let index = Int(arc4random_uniform(count))
        let results = fetchedResultsController.fetchedObjects![index] as! Cards
        return results
    }
    
    // initialize count variable
    var count = 1
    // tap gesture action method
    @objc func flip_card(sender: UITapGestureRecognizer) {
        
        // Display Ads every 5 tap
        if count > 0 && count < (fetchedResultsController.fetchedObjects?.count)! {
            if count % 6 == 0 {
                count = 1
                
                if interstitial.isReady {
                    // pause the game timer
                    time.pause()
                    // show the ads
                    interstitial.present(fromRootViewController: self)
                } else {
                    print("Ad wasn't ready")
                }
                
            }
            count += 1
        }
        
        // display a new card
        card_label.text = randomTask().name!
        
        //flip UIView animation
        UIView.transition(with: card_view, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
}

// Interstitial Ads
extension playVC: GADInterstitialDelegate {
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-5562078941559997/4706460997")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    // ============ GADBannerViewDelegate Methods ===================================================================
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
        
        interstitial = createAndLoadInterstitial()
        
        // resume timer after ads finished
        time.pause()
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }

    // ============ /GADBannerViewDelegate Methods ===================================================================

}

