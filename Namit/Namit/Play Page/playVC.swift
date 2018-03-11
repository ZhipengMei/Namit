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

    @IBOutlet weak var animate_button: UIButton!
    // buttons
    @IBOutlet weak var pause_button: UIButton!
    @IBOutlet weak var namedit_button: UIButton!
    let resumeBtn = UIButton()
    let back_to_play = UIButton()
    
    @IBOutlet weak var takeLife_button: UIButton!
    @IBOutlet weak var dare_button: UIButton!
    
    
    
    
    // labels
    @IBOutlet weak var timer_label: UILabel!
    @IBOutlet weak var card_label: UILabel!
    let punishment_label = UILabel()
    @IBOutlet weak var player_label: UILabel!
    @IBOutlet weak var pickone_label: UILabel!

    // view
    @IBOutlet weak var card_view: UIView!
    let punishment_view = UIView()
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var profile_view: UIView!
    @IBOutlet weak var punishment_option: UIView!
    
    
    

    // current player and upcoming player
    @IBOutlet weak var player1_label: UILabel!
    @IBOutlet weak var player2_label: UILabel!
    //placeholder labels
    var p1_label: UILabel!
    var p2_label: UILabel!
    var p3_label: UILabel!
    // an array of counter for each placeholder labels
    var counters = [-1, 0 ,1]
    
    // total # of players
    var players_count: Int!

    
    // timer class
    let time = Time()
    //bad programming
    var gameTimer: Timer!
    
    //default for NSFetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    //Punishments NSFetchedResultsController
    lazy var punishment_fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Punishments")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    // Selected Players data initialization
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selected_players = [Players]()
    // Create Fetch Request
    var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Players")


    var punishments_data: [NSFetchRequestResult] = []
    var cards_data: [NSFetchRequestResult] = []
    
    // Interstitial_STEP 1: Create an interstitial ad object
    var interstitial: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()            
        
        // fetching coreData
        do {
            try fetchedResultsController.performFetch()
            try punishment_fetchedResultsController.performFetch()
            
            // load coreData to empty variable
            punishments_data = punishment_fetchedResultsController.fetchedObjects!
            cards_data = fetchedResultsController.fetchedObjects!

            fetchRequest.predicate = NSPredicate(format: "section == %d", 0)
            // Add Sort Descriptor
            let sortDescriptor = NSSortDescriptor(key: "row", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            selected_players = try! context.fetch(fetchRequest) as! [Players]
            
            //get total # of players
            players_count = selected_players.count-1
            
        } catch {
            let fetchError = error as NSError
            print("Unable to Save Note")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        // ======================== Button =================
        // pause button
        pause_button.backgroundColor = UIColor.red
        pause_button.setTitleColor(.white, for: .normal)
        pause_button.layer.cornerRadius = self.pause_button.bounds.width * 0.5
        pause_button.titleLabel?.font =  UIFont(name: "helvetica neue", size: 10)
        
        // punishment button
        namedit_button.backgroundColor = UIColor.red
        namedit_button.layer.cornerRadius = self.namedit_button.bounds.height / 2
        namedit_button.setTitleColor(UIColor.white, for: .normal)
            // font & size
        namedit_button.titleLabel?.font =  UIFont(name: "helvetica neue", size: 15)
            // string kerning
        let attributedString = NSMutableAttributedString(string: "PUNISHMENT")
        attributedString.addAttribute(NSAttributedStringKey.kern, value: 15, range: NSRange(location: 0, length: attributedString.length - 1))
        namedit_button.titleLabel?.attributedText = attributedString
            // tap gesture for action
        let namedid_tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(namedit_action(sender:)))
        namedid_tapGestureRecognizer.numberOfTapsRequired = 1
        namedit_button.isUserInteractionEnabled = true
        namedit_button.addGestureRecognizer(namedid_tapGestureRecognizer)
        
        //take life button
        takeLife_button.layer.cornerRadius = takeLife_button.frame.height / 2
        takeLife_button.backgroundColor = UIColor.red
        takeLife_button.setTitleColor(.white, for: .normal)
        
        // dare button
        dare_button.layer.cornerRadius = dare_button.frame.height / 2
        dare_button.backgroundColor = UIColor.red
        dare_button.setTitleColor(.white, for: .normal)
        
        
        // ======================== Label =================
        // player label
        player_label.textColor = UIColor.white
        player1_label.text = "PLAYER 1"
        
        // player1 & player2
        player2_label.font =  UIFont(name: "helvetica neue", size: 15)
        player2_label.text = selected_players[1].name
        player1_label.text = selected_players[0].name
        
        
        // timer label
        timer_label.textColor = UIColor.white
        timer_label.layer.cornerRadius = self.timer_label.bounds.width * 0.5
        timer_label.layer.borderWidth = 3.0
        timer_label.layer.borderColor = (UIColor.white).cgColor
        timer_label.backgroundColor = UIColor.clear
        timer_label.font =  UIFont(name: "helvetica neue", size: 40)
        timer_label.text = String(time.seconds)
        
        // card label
        card_label.textAlignment = .center
        card_label.textColor = .black
        card_label.numberOfLines = 0
        // display the first card
        card_label.text = randomCardTask()
        
        //pick one label
        pickone_label.textColor = .white
        pickone_label.font = UIFont(name: "helvetica neue", size: 15)
        
        
        
        // ======================== View =================
        // dimView
        let defaultDimColor = UIColor.black.withAlphaComponent(0.7)
        dimView.backgroundColor = defaultDimColor
        dimView.isHidden = true
        
        // punishment option view
        punishment_option.isHidden = true
        punishment_option.backgroundColor = UIColor.black.withAlphaComponent(0.95)
        
        //profile view
        profile_view.backgroundColor = UIColor.clear
        profile_view.layer.cornerRadius = self.profile_view.frame.height / 2
        profile_view.layer.borderWidth = 3.0
        profile_view.layer.borderColor = (UIColor.white).cgColor
        
        // card_view
        card_view.backgroundColor = UIColor.white
        card_view.layer.cornerRadius = 10
        
        // native view
        self.view.backgroundColor = UIColor.black
        
        
        
        // setup timer
        time.timerLabel = timer_label
        time.pauseButton = pause_button
        time.runTimer()

        
        // ================= Gesture ==================================================
        // Add tap gesture to card_view
        // The flip_card: method will be fliping the card_view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateScore(sender:)))
        // swipe gesture for action
        let swipe_left = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        swipe_left.direction = .left
        let swipe_right = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        swipe_right.direction = .right
        
        // Optionally set the number of required taps, e.g., 2 for a double click
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        card_view.isUserInteractionEnabled = true
        card_view.addGestureRecognizer(tapGestureRecognizer)
        card_view.addGestureRecognizer(swipe_left)
        card_view.addGestureRecognizer(swipe_right)
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
            print("Advertisement wasn't ready")
        }
        
        // Interstitial_STEP 4: Reload
        interstitial = createAndLoadInterstitial()
        // =================================================================================
        
        // When user tapped on pause button
        // creating dim view layer
//        let defaultDimColor = UIColor.black.withAlphaComponent(0.7)
//        dim_view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        self.view.addSubview(dim_view)
//        dim_view.backgroundColor = defaultDimColor
//        self.dim_view.isHidden = true
        
        // resume button
        // viewDidLoad render a false position due to status bar is hidden and sotryboard design conflict
//        resumeBtn.setTitle("Resume", for: .normal)
//        resumeBtn.backgroundColor = .red
//        let resumeBtn_tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss_dimView(sender:)))
//        resumeBtn_tapGestureRecognizer.numberOfTapsRequired = 1
//        resumeBtn.isUserInteractionEnabled = true
//        resumeBtn.addGestureRecognizer(resumeBtn_tapGestureRecognizer)
//        //self.view.addSubview(resumeBtn)
//        self.dim_view.addSubview(resumeBtn)
//        self.resumeBtn.isHidden = true
        
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
        let tap_tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(back2play_action(sender:)))
        tap_tapGestureRecognizer.numberOfTapsRequired = 1
        back_to_play.isUserInteractionEnabled = true
        back_to_play.addGestureRecognizer(tap_tapGestureRecognizer)
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
        self.punishment_label.frame = CGRect(x: 0 , y: 0 , width: self.card_label.frame.size.width, height: self.card_label.frame.size.height)
        self.punishment_label.center.x = self.punishment_view.center.x
        self.punishment_label.center.y = self.punishment_view.center.y - (self.back_to_play.frame.size.height)
        self.punishment_label.font =  UIFont(name: "HelveticaNeue-Bold", size: 25)
        self.punishment_label.numberOfLines = 0
        self.punishment_label.textColor = .white
        self.punishment_label.textAlignment = .center
        self.punishment_view.addSubview(self.punishment_label)
        
        // ==================== /Punishment View end =============================================================
        
        // bring card_view to front so user can tap for a new card
        //self.view.bringSubview(toFront: card_view)
        
        //TODO
        gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(time.getTime()), target: self, selector: (#selector(display_punishment_Action)), userInfo: nil, repeats: false)
        
    }// \viewDidLoad
    
    // dismiss view
    @IBAction func quit_action(_ sender: Any) {
        //self.timer_beep.pause_action()
        time.stop()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pause_action(_ sender: Any) {
        // pause timer
        time.pause()
        dimView.isHidden = false
    }
    

    // hide resumeBtn and dim_view, then resume timer
    @IBAction func resume_action(_ sender: Any) {
        time.pause()
        dimView.isHidden = true
    }
    
    
    // display punishment view
    @objc func namedit_action(sender: UITapGestureRecognizer) {
        
    }
    
    //TODO
    @objc func display_punishment_Action() {
        time.stop()
        punishment_option.isHidden = false
    }
    
    @IBAction func dare_action(_ sender: Any) {
        show_punishment()
    }
    
    @IBAction func takeLife_action(_ sender: Any) {
        print("Take life clicked")
    }
    
    
    func show_punishment() {
        // assign punishment text
        self.punishment_label.text = randomPunishmentTask()
        
        // bring punishment_view to the front
        self.view.bringSubview(toFront: punishment_view)
        
        // create back_to_play button's frame at run time for accurate position
        self.back_to_play.frame = CGRect(x: self.namedit_button.frame.origin.x, y: self.namedit_button.frame.origin.y, width: 287, height: 63)
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
        //TODO
        UIView.animate(withDuration: 0.3, animations: {
            self.punishment_view.alpha = 0
            self.back_to_play.alpha = 0
            self.punishment_option.isHidden = true
        }, completion: { (finished: Bool) in
            self.time.reset()
            self.gameTimer = Timer.scheduledTimer(timeInterval: TimeInterval(self.time.getTime()), target: self, selector: (#selector(self.display_punishment_Action)), userInfo: nil, repeats: false)
        })
    }
    
    // randomize the order of the Card fetchedObjects
    func randomCardTask() -> String {
        if cards_data.count > 0 {
            return createCardRandom()
        } else {
            cards_data = fetchedResultsController.fetchedObjects!
            return createCardRandom()
        }
    }
    
    func createCardRandom() -> String {
        // random key from array
        let arrayKey = Int(arc4random_uniform(UInt32(cards_data.count)))
        // your random number
        let randNum = (cards_data[arrayKey] as! Cards).name!
        print(randNum)
        // make sure the number isnt repeated
        cards_data.remove(at: arrayKey)
        return randNum
    }
    
    // randomize the order of the fetchedObjects
    func randomPunishmentTask() -> String {
        if punishments_data.count > 0 {
            return createPunishmentRandom()
        } else {
            punishments_data = punishment_fetchedResultsController.fetchedObjects!
            return createPunishmentRandom()
        }
    }
    
    func createPunishmentRandom() -> String {
        // random key from array
        let arrayKey = Int(arc4random_uniform(UInt32(punishments_data.count)))
        // your random number
        let randNum = (punishments_data[arrayKey] as! Punishments).name!
        print(randNum)
        // make sure the number isnt repeated
        punishments_data.remove(at: arrayKey)
        return randNum
    }
    
    
    // initialize count variable
    var count = 1
    // tap gesture action method
    @objc func flip_card(sender: Any) {
        
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
        card_label.text = randomCardTask()
        
        //flip UIView animation
        UIView.transition(with: card_view, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.left:
            print("swiped left")
            break
        case UISwipeGestureRecognizerDirection.right:
            print("swiped right")
            self.flip_card(sender: UISwipeGestureRecognizer())
            break
        default:
            break
        }
    }
    
    // refresh timer
    @objc func updateScore(sender: Any) {
        time.reset()
    }
    
    
    //
    @IBAction func quitzzzzzz(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // ========================== Calling the animation funtions
    @IBAction func animate_Action(_ sender: Any) {
        self.animate_button.isEnabled = false
        self.player1_label.alpha = 0
        self.player2_label.alpha = 0

        //update counter
        for i in 0..<counters.count {
            if counters[i] < players_count {
                counters[i] += 1
            } else {
                // counter is out of rnage
                counters[i] = 0
            }
        }
        
        create_players(p1_name: selected_players[counters[0]].name!, p2_name: selected_players[counters[1]].name!, p3_name: selected_players[counters[2]].name!)

        self.animate_players(p1: self.p1_label, p2: self.p2_label, p3: p3_label)
    }
    //==========================
    
}

// =============== players rotation animation  ==========================
extension playVC {
    
    func animate_players(p1: UILabel, p2: UILabel, p3: UILabel) {
        //p2.enlarge_move(fontSize: 40, duration: 0.7, x_pos: 40.2, y_pos: -0.8)
        p2.enlarge_move(fontSize: 40, duration: 0.7, x_pos: 33, y_pos: -0.6)
        self.shrink(label: p1, x_pos: 15)
        p3.enlarge_move(fontSize: 15, duration: 0.7, x_pos: 0, y_pos: 0)
    }
    
    //shrink the emoji
    func shrink(label: UILabel, x_pos: CGFloat) {
        let originalTransform = label.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.1, y: 0.1)
        let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: x_pos, y: 0)
        UIView.animate(withDuration: 0.7, animations: {
            label.transform = scaledAndTranslatedTransform
        }, completion: { (finished: Bool) in
            self.player1_label.alpha = 1
            self.player2_label.alpha = 1
            self.p1_label.removeFromSuperview()
            self.p1_label = nil
            self.p2_label.removeFromSuperview()
            self.p2_label = nil
            self.p3_label.removeFromSuperview()
            self.p3_label = nil
            self.animate_button.isEnabled = true
        })
    }
    
    //enlarge the emoji and move to the right
    func create_players(p1_name: String, p2_name: String, p3_name: String) {
        // setup place holders labels
        self.p3_label = UILabel(frame: CGRect(x: self.player2_label.frame.origin.x, y: self.player2_label.frame.origin.x, width: 48, height: 48))
        self.p3_label.center = self.player2_label.center
        self.p3_label.textAlignment = .center
        self.p3_label.text = p3_name
        self.p3_label.font = UIFont(name: "helvetica neue", size: 8.3)
        self.profile_view.addSubview(self.p3_label)
        
        self.p1_label = self.player1_label.copyLabel()
        self.p1_label.text = p1_name
        self.profile_view.addSubview(self.p1_label)
        
        self.p2_label = self.player2_label.copyLabel()
        self.p2_label.text = p2_name
        self.profile_view.addSubview(self.p2_label)
        
        // update the fixed labels
        self.player1_label.text = p2_name
        self.player2_label.text = p3_name
        
    }
}
// ==============================================================================




// animation functions
extension UILabel {
    func enlarge_move(fontSize: CGFloat, duration: TimeInterval, x_pos: CGFloat, y_pos: CGFloat) {
        let startTransform = transform
        let oldFrame = frame
        var newFrame = oldFrame
        let scaleRatio = fontSize / font.pointSize
        
        newFrame.size.width *= scaleRatio
        newFrame.size.height *= scaleRatio
        newFrame.origin.x = oldFrame.origin.x - (newFrame.size.width - oldFrame.size.width) * 0.5
        newFrame.origin.y = oldFrame.origin.y - (newFrame.size.height - oldFrame.size.height) * 0.5
        frame = newFrame
        
        font = font.withSize(fontSize)
        
        transform = CGAffineTransform.init(scaleX: 1 / scaleRatio, y: 1 / scaleRatio);
        layoutIfNeeded()
        
        UIView.animate(withDuration: duration, animations: {
            self.transform = startTransform
            newFrame = self.frame
            self.frame.origin.x += x_pos
            self.frame.origin.y += y_pos
        }) { (Bool) in
            self.frame = newFrame
            self.frame.origin.x += x_pos
            self.frame.origin.y += y_pos
        }
    }
    
}

// make a clone of the label
extension UILabel {
    func copyLabel() -> UILabel {
        let label = UILabel()
        label.font = self.font
        label.frame = self.frame
        label.text = self.text
        return label
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
    
    // ============ GADBannerViewDelegate Methods =====================
    
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
    
    // ============ /GADBannerViewDelegate Methods ======================
    
}



