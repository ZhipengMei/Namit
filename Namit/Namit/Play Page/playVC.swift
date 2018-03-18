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
    @IBOutlet weak var pause_button: UIButton!
    @IBOutlet weak var namedit_button: UIButton!
    let resumeBtn = UIButton()
    @IBOutlet weak var mute_btn: UIButton!
    @IBOutlet weak var quit_btn: UIButton!
    @IBOutlet weak var resume_btn: UIButton!
    
    // labels
    @IBOutlet weak var timer_label: UILabel!
    @IBOutlet weak var card_label: UILabel!
    @IBOutlet weak var player_label: UILabel!
    @IBOutlet weak var hp_label: UILabel!
    
    // view
    @IBOutlet weak var card_view: UIView!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var profile_view: UIView!
    
    // current player and upcoming player
    @IBOutlet weak var player1_label: UILabel!
    @IBOutlet weak var player2_label: UILabel!
    //placeholder labels
    var p1_label: UILabel!
    var p2_label: UILabel!
    var p3_label: UILabel!
    // an array of counter for each placeholder labels
    var mul_counters = [-1, 0 ,1]
    var two_counters = [-1, 0]
    
    // timer class
    let time = Time()
    
    // pause || resume
    var resumeTapped = false
    
    //punishment View
    @IBOutlet weak var punishmentView: UIView!
    @IBOutlet weak var punishmentLabel: UILabel!
    @IBOutlet weak var takelifeBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    
    
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
    
    // TO DO experimental
    var players_data = [Person]()
    var current_player: Person!
    
    // initialize count variable for "flip_card" function
    var count = 1
    
    // dialog view
    var dialogView = UIView()
    var dialoglabel = UILabel()
    
    // fetching coreData
    private func fetchCoreData() {
        do {
            try fetchedResultsController.performFetch()
            try punishment_fetchedResultsController.performFetch()
            
            // load coreData to empty variable
            punishments_data = punishment_fetchedResultsController.fetchedObjects!
            cards_data = fetchedResultsController.fetchedObjects!
            
            selected_players = CoreDataHelper().fetch(context: context, entityName: "Players", sortDescriptorKey: "selected_row", selected: 1, isPredicate: true) as! [Players]
            
            // assign fetched player data into players_data[Person] array
            for i in 0..<selected_players.count {
                let p = selected_players[i]
                //let person = Person(charName: p.name!, hp: 3, playerOrder: i, playerName: "Player \(i + 1)")
                let person = Person(charName: p.name!, hp: 1, playerOrder: i, playerName: "Player \(i + 1)")
                players_data.append(person)
            }
            
            //initialize current player
            self.current_player = players_data[0]
            
            // player label
            player_label.textColor = UIColor.white
            player_label.text = players_data[0].playerName
            
            // initalize player1 & player2
            player2_label.text = players_data[1].charName
            
            player1_label.text = self.current_player.charName
            display_heart(hp: self.current_player.hp)
            
        } catch {
            let fetchError = error as NSError
            print("Unable to Save Note")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // fetching coreData
        fetchCoreData()
        //initialize UI components
        setupLayout()
    }// \viewDidLoad
    
    
    
    // dismiss view
    @IBAction func quit_action(_ sender: Any) {
        //TODO
        //self.timer_beep.pause_action()
        time.stop()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pause_action(_ sender: Any) {
        
        if self.resumeTapped == false {
            resumeTapped = true
            dimView.isHidden = false
            time.pause() // pause timer
        } else {
            resumeTapped = false
            dimView.isHidden = true
            time.pause() // pause timer
        }
    }
    
    @IBAction func mute_action(_ sender: Any) {
        //fase means mute
        if settingVC().getSound() == false {
            settingVC().saveSoundBool(isSoundOn: true)
            mute_btn.setTitle("MUTE", for: .normal)
            print("clicked mute")
        } else {
            //play sound
            settingVC().saveSoundBool(isSoundOn: false)
            //title is the opposite of play sound to indicate an optional action
            mute_btn.setTitle("PLAY SOUND", for: .normal)
            print("clicked Play sound")
        }
    }
    
    
    // rotate to next player
    @objc func namedit_action(sender: UITapGestureRecognizer) {
        
        //self.namedit_button.isHidden = true
        self.namedit_button.isUserInteractionEnabled = false
        self.namedit_button.isEnabled = false
        
        //disable pause button to avoid creation of multiple timer conflict
        self.pause_button.isEnabled = false

        self.time.stop()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.rotate_players()
        }
        self.resumeTImer()
    }
    
    @IBAction func done_action(_ sender: Any) {
        //rotate next player, begin timer
        UIView.animate(withDuration: 0.3, animations: {
            self.punishmentView.alpha = 0
        }, completion: { (finished: Bool) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.rotate_players()
            }
            self.resumeTImer()
        })
    }
    
    //remove a health point from player
    @IBAction func takeLife_action(_ sender: Any) {
        
        //dismiss punishment view
        punishmentView.alpha = 0
        
        //pause 0.5 second then refresh the health point label
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // change 2 to desired number of seconds
            //current lose one health point
            self.current_player.hp -= 1
            self.display_heart(hp: self.current_player.hp)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            //the player lost the game
            if self.current_player.hp == 0 {
                self.time.stop()
                // remove player from the game (players_data)
                self.players_data.remove(at: self.current_player.playerOrder)
                
                //Game over condition
                if self.players_data.count == 1 {
                    self.time.stop()
                    print("GAME OVER")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "winner") as! WinnerVC
                    controller.winner = self.players_data[0]
                    self.present(controller, animated: true, completion: nil)
                } else {
                    // re-order the players_data
                    // should not change the .playerOrder <-- used for display player name
                    for i in 0..<self.players_data.count {
                        self.players_data[i].playerOrder = i
                    }
                    self.createDialogView(message: "\(self.current_player.charName) IS OUT")
                    //fade in and out of the dialog view
                    self.fadeViewInThenOut(view: self.dialogView, delay: 2)
                }
            } // end if
            
            if self.players_data.count > 1 {
                // pause 1 section then rotate player icon
                self.rotate_players()
                
                //pause 1 section then begin timer
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // change 1 to desired number of seconds
                    self.resumeTImer()
                }
            }
            else if self.players_data.count == 1 {
                self.time.stop()
                print("GAME OVER")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "winner") as! WinnerVC
                controller.winner = self.players_data[0]
                self.present(controller, animated: true, completion: nil)
            }
        }
        
    }
    
    //Pop up dialog view to indicate who is out of the game
    func createDialogView(message: String) {
        //dialog view
        dialogView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        dialogView.center = self.view.center
        dialogView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        self.view.addSubview(dialogView)
        
        //dialog label
        dialoglabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        dialoglabel.center = dialogView.center
        dialoglabel.textAlignment = .center
        dialoglabel.text = message
        dialoglabel.textColor = UIColor.white
        dialoglabel.alpha = 1
        dialoglabel.numberOfLines = 0
        dialoglabel.font = UIFont(name: "Viga", size: 80)
        dialogView.addSubview(dialoglabel)
    }
    
    func fadeViewInThenOut(view : UIView, delay: TimeInterval) {
        let animationDuration = 0.25
        // Fade in the view
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            view.alpha = 1
        }) { (Bool) -> Void in
            // After the animation completes, fade out the view after a delay
            UIView.animate(withDuration: animationDuration, delay: delay, options: .curveEaseInOut, animations: { () -> Void in
                view.alpha = 0
            },completion: { (Bool) -> Void in
                view.removeFromSuperview()
            })
        }
    }
    
    // health point (hp) label
    func display_heart(hp: Int) {
        switch hp {
        case 0: hp_label.text = "💔💔💔"
            break
        case 1: hp_label.text = "❤️"
            break
        case 2: hp_label.text = "❤️❤️"
            break
        case 3: hp_label.text = "❤️❤️❤️"
            break
        default: hp_label.text = "💔💔💔"
            break
        }
    }
    
}










// =============== punishment view ==========================
extension playVC {
    func resumeTImer() {
        //delay technique
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // change 2 to desired number of seconds
            self.time.seconds = self.time.getTime()
            self.time.timerLabel.text = String(self.time.seconds)

            // Your code with delay
            self.time.stop()
            self.time.runTimer()
        }
    }
}


// =============== swip & randomize Cards' order ==========================
extension playVC {
    
    // tap gesture action method
    @objc func flip_card(sender: Any) {
        // Display Ads every 5 tap
        if count > 0 && count < (fetchedResultsController.fetchedObjects?.count)! {
            if count % 10 == 0 {
                count = 1
                if interstitial.isReady {
                    // pause the timer when ads show up
                    time.stop()
                    // show the ads
                    interstitial.present(fromRootViewController: self)
                } else {
                    print("Warning: Ad wasn't ready")
                }
            }
            count += 1
        }
        // display a new card
        card_label.text = randomCardTask()
        //flip UIView animation
        UIView.transition(with: card_view, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
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
    
}



// =============== players rotation animation  ==========================
extension playVC {
    
    //Calling the animation funtions
    func rotate_players() {
        
        self.player1_label.alpha = 0
        self.player2_label.alpha = 0
 
        if self.players_data.count < 3 {
            //update counter
            print("self.players_data.count ", self.players_data.count)
            for i in 0..<two_counters.count {
                print("i is: ", i)
                if two_counters[i] < self.players_data.count-1 {
                    two_counters[i] += 1
                } else {
                    // counter is out of rnage
                    two_counters[i] = 0
                }
            }
          
            // two players rotation, put player one back at the end
            create_players(p1_name: players_data[two_counters[0]].charName, p2_name: players_data[two_counters[1]].charName, p3_name: players_data[two_counters[0]].charName)
            // the next player is the new current player
            self.current_player = players_data[two_counters[1]]
        } else {
            //update mul_counter
            for i in 0..<mul_counters.count {
                if mul_counters[i] < self.players_data.count-1 {
                    mul_counters[i] += 1
                } else {
                    // counter is out of rnage
                    mul_counters[i] = 0
                }
            }
            //multiple players rotation
            create_players(p1_name: players_data[mul_counters[0]].charName, p2_name: players_data[mul_counters[1]].charName, p3_name: players_data[mul_counters[2]].charName)
            //reset the current player
            self.current_player = players_data[mul_counters[1]]
        }
        
        //healthpoint comes after player icon rotation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            //fade in the next player's healthpoint
            UIView.animate(withDuration: 0.3, animations: {
                //reset the healthpoint for next player
                self.display_heart(hp: self.current_player.hp)
                self.player_label.text = self.current_player.playerName
                self.hp_label.alpha = 1
                self.player_label.alpha = 1
            })
        }
        self.animate_players(p1: self.p1_label, p2: self.p2_label, p3: p3_label)
    }
    
    func animate_players(p1: UILabel, p2: UILabel, p3: UILabel) {
        p2.enlarge_move(fontSize: 40, duration: 0.7, x_pos: (player1_label.center.x - player2_label.center.x) + 5, y_pos: 0)
        //fade out the current player's healthpoint at the beginning of the rotation
        UIView.animate(withDuration: 0.3, animations: {
            self.hp_label.alpha = 0
            self.player_label.alpha = 0
        })
        self.shrink(label: p1, x_pos: 15)
        p3.enlarge_move(fontSize: 15, duration: 0.7, x_pos: 0, y_pos: 0.5)
    }
    
    //shrink the emoji
    func shrink(label: UILabel, x_pos: CGFloat) {
        let originalTransform = label.transform
        let scaledTransform = originalTransform.scaledBy(x: 0.1, y: 0.1)
        let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: x_pos, y: 0)
        UIView.animate(withDuration: 0.7, animations: {
            label.transform = scaledAndTranslatedTransform
        }, completion: { (finished: Bool) in

            UIView.animate(withDuration: 1.0, animations: {
                self.player2_label.alpha = 1
                self.player1_label.alpha = 1
                self.profile_view.bringSubview(toFront: self.player2_label)
                self.profile_view.bringSubview(toFront: self.player1_label)
            }, completion: { (finished: Bool) in
                self.p1_label.removeFromSuperview()
                self.p1_label = nil
                self.p2_label.removeFromSuperview()
                self.p2_label = nil
                self.p3_label.removeFromSuperview()
                self.p3_label = nil
            })
            
//            self.player2_label.alpha = 1
//            self.player1_label.alpha = 1
//            self.profile_view.bringSubview(toFront: self.player2_label)
//            self.profile_view.bringSubview(toFront: self.player1_label)
//
//            self.p1_label.removeFromSuperview()
//            self.p1_label = nil
//            self.p2_label.removeFromSuperview()
//            self.p2_label = nil
//            self.p3_label.removeFromSuperview()
//            self.p3_label = nil
            
            //enable the button after  rotation animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.namedit_button.isUserInteractionEnabled = true
                self.namedit_button.isEnabled = true
                self.pause_button.isEnabled = true
            }
        })
    }
    
    //enlarge the emoji and move to the right
    func create_players(p1_name: String, p2_name: String, p3_name: String) {
        // setup place holders labels
        self.p3_label = UILabel(frame: CGRect(x: self.player2_label.frame.origin.x, y: self.player2_label.frame.origin.y, width: 21, height: 18))
        self.p3_label.center = self.player2_label.center
        self.p3_label.textAlignment = .center
        self.p3_label.text = p3_name
        self.p3_label.font = UIFont(name: "Viga", size: 1)
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



extension UILabel {
    // animation functions
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
    
    // make a clone of the label
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
        self.time.reset()
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
    
    // ============ /GADBannerViewDelegate Methods ======================
    
}



//UI components
extension playVC {
    //initialize UI components
    private func setupLayout() {
        // ======================== Button =================
        // pause button
        pause_button.setTitleColor(.white, for: .normal)
        pause_button.layer.cornerRadius = self.pause_button.bounds.width * 0.5
        
        // punishment button
        namedit_button.layer.cornerRadius = self.namedit_button.bounds.height / 2
        namedit_button.setTitleColor(UIColor.white, for: .normal)
        // font & size
        //namedit_button.titleLabel?.font =  UIFont(name: "helvetica neue", size: 15)
        // string kerning
        //let attributedString = NSMutableAttributedString(string: "PUNISHMENT")
        //attributedString.addAttribute(NSAttributedStringKey.kern, value: 15, range: NSRange(location: 0, length: attributedString.length - 1))
        //namedit_button.titleLabel?.attributedText = attributedString
        // tap gesture for action
        let namedid_tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(namedit_action(sender:)))
        namedid_tapGestureRecognizer.numberOfTapsRequired = 1
        namedit_button.isUserInteractionEnabled = true
        namedit_button.addGestureRecognizer(namedid_tapGestureRecognizer)
        
        /* ======================== View ================= */
        // dimView
        dimView.isHidden = true
        
        //profile view
        profile_view.backgroundColor = UIColor.clear
        profile_view.layer.cornerRadius = self.profile_view.frame.height / 2
        profile_view.layer.borderWidth = 3.0
        profile_view.layer.borderColor = (UIColor.white).cgColor
        
        // card_view
        card_view.backgroundColor = UIColor.clear
        card_view.layer.cornerRadius = 10
        card_view.layer.borderWidth = 3
        card_view.layer.borderColor = (UIColor.white).cgColor
        
        /* ======================== Label ================= */
        // timer label
        timer_label.textColor = UIColor.white
        timer_label.layer.cornerRadius = self.timer_label.bounds.width * 0.5
        timer_label.layer.borderWidth = 3.0
        timer_label.layer.borderColor = (UIColor.white).cgColor
        timer_label.backgroundColor = UIColor.clear        
        timer_label.text = String(time.seconds)
        view.bringSubview(toFront: timer_label)
        
        // card label
        card_label.textAlignment = .center
        card_label.textColor = .white
        card_label.numberOfLines = 0
        // display the first card
        card_label.text = randomCardTask()
        
        
        
        // setup timer
        time.timerLabel = timer_label
        time.pauseButton = pause_button
        time.punishmentView = punishmentView
        punishmentView.alpha = 0
        
        // start timer
        time.runTimer()
        
        
        /* ================= Gesture ================================================== */
        // Add tap gesture to card_view
        // swipe gesture for action
        let swipe_left = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        swipe_left.direction = .left
        let swipe_right = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        swipe_right.direction = .right
        
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        card_view.isUserInteractionEnabled = true
        card_view.addGestureRecognizer(swipe_left)
        card_view.addGestureRecognizer(swipe_right)
        // =================================================================================
        
        
        /* ================= Interstitial Ads ================================================== */
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
        // ========================= end Ads==================================================
        
        
        /*===============  Punishment View ===============*/
        punishmentLabel.text = randomPunishmentTask()
        punishmentLabel.numberOfLines = 0
        punishmentLabel.textColor = .white
        punishmentLabel.textAlignment = .center
        
        // doneBtn
        doneBtn.layer.cornerRadius = doneBtn.frame.height / 2
        
        //takelifeBtn
        takelifeBtn.layer.borderWidth = 3.0
        takelifeBtn.layer.borderColor = (UIColor.white).cgColor
        takelifeBtn.layer.cornerRadius = takelifeBtn.bounds.height / 2
        // ========================= end Punishment view ============
        
        
        /*===============  Pause View ===============*/
        if settingVC().getSound() == false {
            mute_btn.setTitle("PLAY SOUND", for: .normal)
        } else {
            mute_btn.setTitle("MUTE", for: .normal)
        }
        mute_btn.layer.cornerRadius = mute_btn.frame.height / 2
        mute_btn.setTitleColor(UIColor.white, for: .normal)
        
        quit_btn.layer.cornerRadius = quit_btn.frame.height / 2
        quit_btn.setTitleColor(UIColor.white, for: .normal)
    
        /*=============== End Pause View ===============*/
    }
}







