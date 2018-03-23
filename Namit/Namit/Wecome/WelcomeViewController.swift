//
//  WelcomeViewController.swift
//  Namit
//
//  Created by Adrian on 3/22/18.
//  Copyright © 2018 Mei. All rights reserved.
//

import UIKit
import Lottie

class WelcomeViewController: UIViewController {

    var animateview = LOTAnimationView()
    
    @IBOutlet weak var continue_button: UIButton!
    //@IBOutlet weak var lottie_view: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //lottie view
        animateview = LOTAnimationView(name: "namit_tutorial_02")
        //animateview.frame.size = CGSize(width: displayWidth, height: displayHeight)
        animateview.center = self.view.center
        self.view.addSubview(animateview)
        animateview.play()
        animateview.loopAnimation = true

        view.bringSubview(toFront: continue_button)
    }

    @IBAction func continue_action(_ sender: Any) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let home_vc = storyboard.instantiateViewController(withIdentifier: "home") as UIViewController
        self.present(home_vc, animated: true, completion: nil)
        
        
    }
    
}
