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
    let resumeBtn = UIButton()
    let back_to_play = UIButton()
    
    // labels
    @IBOutlet weak var exit_label: UILabel!
    @IBOutlet weak var pause_label: UILabel!
    @IBOutlet weak var timer_label: UILabel!
    @IBOutlet weak var card_label: UILabel!
    let punishment_label = UILabel()
    
    
    // view
    @IBOutlet weak var card_view: UIView!
    let dim_view = UIView()
    let punishment_view = UIView()
    
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
        exit_button.setTitleColor(.white, for: .normal)
        exit_button.layer.cornerRadius = self.exit_button.bounds.width * 0.5
        
        // pause button
        pause_button.backgroundColor = UIColor.red
        pause_button.setTitleColor(.white, for: .normal)
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
            // tap gesture for action
        let pusnish_tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(punishment_action(sender:)))
        pusnish_tapGestureRecognizer.numberOfTapsRequired = 1
        punishment_button.isUserInteractionEnabled = true
        punishment_button.addGestureRecognizer(pusnish_tapGestureRecognizer)
        
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
        
        // native view
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
        
        // When user tapped on pause button
        // creating dim view layer
        let defaultDimColor = UIColor.black.withAlphaComponent(0.7)
        dim_view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(dim_view)
        dim_view.backgroundColor = defaultDimColor
        self.dim_view.isHidden = true
        
        // resume button
        // viewDidLoad render a false position due to status bar is hidden and sotryboard design conflict
        resumeBtn.setTitle("R", for: .normal)
        resumeBtn.backgroundColor = .red
        let resumeBtn_tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss_dimView(sender:)))
        resumeBtn_tapGestureRecognizer.numberOfTapsRequired = 1
        resumeBtn.isUserInteractionEnabled = true
        resumeBtn.addGestureRecognizer(resumeBtn_tapGestureRecognizer)
        self.view.addSubview(resumeBtn)
        self.resumeBtn.isHidden = true
        
        // ======================= Punishment View ==========================================================
        // punishment view
        self.punishment_view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.punishment_view.backgroundColor = .red
        self.view.addSubview(punishment_view)
        self.punishment_view.alpha = 0
        
        // back_to_play button
            // creating button within punishment view
        back_to_play.setTitle("Back To Play", for: .normal)
        back_to_play.setTitleColor(.white, for: .normal)
        back_to_play.backgroundColor = .clear
            // action when tapped
        let tbp_tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(back2play_action(sender:)))
        tbp_tapGestureRecognizer.numberOfTapsRequired = 1
        back_to_play.isUserInteractionEnabled = true
        back_to_play.addGestureRecognizer(tbp_tapGestureRecognizer)
            // add buttont to subview
        self.punishment_view.addSubview(back_to_play)
        back_to_play.alpha = 0
            // font & size
        back_to_play.titleLabel?.font =  UIFont(name: "helvetica neue", size: 15)
            // string kerning
        let btp_attributedString = NSMutableAttributedString(string: "Back To Play")
        btp_attributedString.addAttribute(NSAttributedStringKey.kern, value: 4, range: NSRange(location: 0, length: btp_attributedString.length - 1))
        back_to_play.titleLabel?.attributedText = btp_attributedString
        
        // punishment label
//        self.punishment_label.frame = CGRect(x: self.view.frame.origin.x , y: self.card_label.frame.origin.y , width: self.card_label.frame.size.width, height: self.card_label.frame.size.height)
        self.punishment_label.frame = CGRect(x: 0 , y: 0 , width: self.card_label.frame.size.width, height: self.card_label.frame.size.height)
        self.punishment_label.center.x = self.punishment_view.center.x
        self.punishment_label.center.y = self.punishment_view.center.y - (self.back_to_play.frame.size.height)
        self.punishment_label.text = "Give piggy ride to everybody."
        self.punishment_label.font =  UIFont(name: "HelveticaNeue-Bold", size: 25)
        self.punishment_label.numberOfLines = 0
        self.punishment_label.textColor = .white
        self.punishment_label.textAlignment = .center
        self.punishment_view.addSubview(self.punishment_label)
        
        // ==================== /Punishment View =============================================================
        
        // bring card_view to front so user can tap for a new card
        self.view.bringSubview(toFront: card_view)
    }
    
    // dismiss view
    @IBAction func exit_action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pause_action(_ sender: Any) {
        // pause timer
        time.pause()
        
        // get the pause_button's run time accurate position,
        resumeBtn.frame = CGRect(x: pause_button.frame.origin.x,y: pause_button.frame.origin.y - UIApplication.shared.statusBarFrame.height, width: pause_button.frame.size.width, height:pause_button.frame.size.height)
        resumeBtn.layer.cornerRadius = resumeBtn.bounds.width * 0.5
        self.view.bringSubview(toFront: resumeBtn)
        self.dim_view.isHidden = false
        self.resumeBtn.isHidden = false
    }
    

    // hide resumeBtn and dim_view, then resume timer
    @objc func dismiss_dimView(sender: UITapGestureRecognizer) {
        
        self.dim_view.isHidden = true
        self.resumeBtn.isHidden = true
        time.pause()
        
    }
    
    // display punishment view
    @objc func punishment_action(sender: UITapGestureRecognizer) {

        // bring punishment_view to the front
        self.view.bringSubview(toFront: punishment_view)
        
        // create back_to_play button's frame at run time for accurate position
        self.back_to_play.frame = CGRect(x: self.punishment_button.frame.origin.x, y: self.punishment_button.frame.origin.y, width: 287, height: 63)
        // border
        back_to_play.layer.borderWidth = 3.0
        back_to_play.layer.borderColor = (UIColor.white).cgColor
        // cornerRadius
        back_to_play.layer.cornerRadius = back_to_play.bounds.height / 2
        
        // fade in animation
        UIView.animate(withDuration: 0.2, animations: {
            self.punishment_view.alpha = 1
            self.back_to_play.alpha = 1
        })
        
    }
    
    // dismiss punishment view
    @objc func back2play_action(sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.punishment_view.alpha = 0
            self.back_to_play.alpha = 0
        })
        
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

