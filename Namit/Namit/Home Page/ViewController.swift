//
//  ViewController.swift
//  Namit
//
//  Created by Adrian on 2/2/18.
//  Copyright © 2018 Mei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // buttons
    @IBOutlet weak var play_button: UIButton!
    @IBOutlet weak var setting_button: UIButton!
    @IBOutlet weak var rule_button: UIButton!
    
    // labels
    @IBOutlet weak var setting_label: UILabel!
    @IBOutlet weak var rule_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // play btn
//        self.play_button.clipsToBounds = true
        self.play_button.backgroundColor = UIColor.red
        self.play_button.layer.cornerRadius = self.play_button.bounds.size.width * 0.5
        self.play_button.setTitleColor(UIColor.white, for: .normal)
        //kerning
        let attributedString = NSMutableAttributedString(string: "PLAY")
        attributedString.addAttribute(NSAttributedStringKey.kern, value: 15, range: NSRange(location: 0, length: attributedString.length - 1))
        self.play_button.titleLabel?.attributedText = attributedString
        //font and size
        self.play_button.titleLabel?.font =  UIFont(name: "helvetica neue", size: 20)
        
        // setting btn
        self.setting_button.backgroundColor = UIColor.red
        self.setting_button.layer.cornerRadius = self.setting_button.bounds.size.width * 0.5
        self.setting_button.setTitleColor(UIColor.white, for: .normal)
        
        // rule btn
        self.rule_button.backgroundColor = UIColor.red
        self.rule_button.layer.cornerRadius = self.rule_button.bounds.size.width * 0.5
        self.rule_button.setTitleColor(UIColor.white, for: .normal)
        
        // setting label
        setting_label.textColor = UIColor.blue
        
        //rule label
        rule_label.textColor = UIColor.blue
        
        // view
        self.view.backgroundColor = UIColor.orange
        
        
    }

    
    @IBAction func play_action(_ sender: Any) {
        // programatically push segue to another VC
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "play")
            else {
                print("View controller play not found")
            return
            }
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func setting_action(_ sender: Any) {
        // programatically push segue to another VC
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "settings")
            else {
                print("View controller setting not found")
                return
            }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func rule_action(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "rules")
            else {
                print("View controller play not found")
                return
        }
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //nav bar background color
        //        self.navigationController?.navigationBar.barTintColor = UIColor.red
        
        // Hide the navigation bar on the this view controller
        //        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // change color of navigation bar items (buttons)
        //        self.navigationController?.navigationBar.tintColor = UIColor.blue
        
        // change color of navigation bar title
        //        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.blue]
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    

}

