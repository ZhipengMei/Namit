//
//  WinnerVC.swift
//  Namit
//
//  Created by Adrian on 3/14/18.
//  Copyright © 2018 Mei. All rights reserved.
//

import UIKit

class WinnerVC: UIViewController {

    @IBOutlet weak var winner_label: UILabel!
    @IBOutlet weak var emoji_label: UILabel!
    @IBOutlet weak var playerName_label: UILabel!
    @IBOutlet weak var finish_button: UIButton!
    
    var winner: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        finish_button.layer.cornerRadius = finish_button.frame.height / 2
        
        if winner != nil {
            emoji_label.text = winner?.charName
            playerName_label.text = winner?.playerName
        }
    }

    @IBAction func finish_action(_ sender: Any) {
        //present VC and keep the nav bar
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "home") as! ViewController
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    

}
