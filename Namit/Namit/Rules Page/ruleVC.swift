//
//  ruleVC.swift
//  Namit
//
//  Created by Adrian on 2/3/18.
//  Copyright © 2018 Mei. All rights reserved.
//

import UIKit
import Lottie

class ruleVC: UIViewController {

    // graphic labels
    @IBOutlet weak var play_label: UILabel!
    @IBOutlet weak var card_label: UILabel!
    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var punishment_label: UILabel!
    
    // text labels
    @IBOutlet weak var tap_label: UILabel!
    @IBOutlet weak var toplay_label: UILabel!
    @IBOutlet weak var namethings_label: UILabel!
    @IBOutlet weak var in_label: UILabel!
    @IBOutlet weak var seconds_label: UILabel!
    @IBOutlet weak var oryouwill_label: UILabel!
    @IBOutlet weak var dot_label: UILabel!
    
    // button
    @IBOutlet weak var back_button: UIButton!
    
    //lottie view
    @IBOutlet weak var little_tutorial: UIView!
    var animateview = LOTAnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // customize graphic labels
        play_label.backgroundColor = UIColor.red
        play_label.textColor = UIColor.white
        play_label.layer.cornerRadius = self.play_label.bounds.width * 0.5
        play_label.clipsToBounds = true
        //kerning
        let attributedString = NSMutableAttributedString(string: "PLAY")
        attributedString.addAttribute(NSAttributedStringKey.kern, value: 5, range: NSRange(location: 0, length: attributedString.length - 1))
        self.play_label.attributedText = attributedString
        //font and size
        self.play_label.font =  UIFont(name: "helvetica neue", size: 15)
        
        card_label.backgroundColor = UIColor.white
        card_label.layer.cornerRadius = 10
        card_label.clipsToBounds = true

        time_label.backgroundColor = UIColor.clear
        time_label.textColor = UIColor.white
        time_label.layer.cornerRadius = self.time_label.bounds.width * 0.5
        time_label.layer.borderWidth = 2.0
        time_label.layer.borderColor = (UIColor.white).cgColor
        time_label.font =  UIFont(name: "helvetica neue", size: 40)
        time_label.clipsToBounds = true

        punishment_label.backgroundColor = UIColor.red
        punishment_label.textColor = UIColor.white
        punishment_label.layer.cornerRadius = self.punishment_label.frame.height / 2
        punishment_label.clipsToBounds = true
        
        // customize text labels
        tap_label.textColor = UIColor.white
        toplay_label.textColor = UIColor.white
        namethings_label.textColor = UIColor.white
        in_label.textColor = UIColor.white
        seconds_label.textColor = UIColor.white
        oryouwill_label.textColor = UIColor.white
        dot_label.textColor = UIColor.white
        
        
        // view
        self.view.backgroundColor = UIColor.black
        
        //let displayWidth: CGFloat = self.view.frame.width
        //let displayHeight: CGFloat = self.view.frame.height
        //lottie view
        animateview = LOTAnimationView(name: "namit_tutorial_02")
        //animateview.frame.size = CGSize(width: displayWidth, height: displayHeight - back_button.frame.height - 10)
        animateview.center = self.little_tutorial.center
        self.view.addSubview(animateview)
        animateview.play()
        animateview.loopAnimation = true
        
        // back button
        back_button.backgroundColor = UIColor.clear
        back_button.layer.cornerRadius = self.back_button.frame.height / 2
        back_button.setTitleColor(UIColor.white, for: .normal)
        back_button.layer.borderWidth = 3.0
        back_button.layer.borderColor = (UIColor.white).cgColor
        view.bringSubview(toFront: back_button)
    }

    @IBAction func back_action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
}
