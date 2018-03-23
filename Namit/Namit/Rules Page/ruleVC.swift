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
    
    // button
    @IBOutlet weak var back_button: UIButton!
    
    //lottie view
    @IBOutlet weak var little_tutorial: UIView!
    var animateview = LOTAnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view
        self.view.backgroundColor = UIColor.black
        
        //lottie view
        animateview = LOTAnimationView(name: "namit_tutorial_02")
        //animateview.frame.size = CGSize(width: displayWidth, height: displayHeight)
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
