//
//  ViewController.swift
//  NameIt
//
//  Created by Adrian on 12/27/17.
//  Copyright © 2017 zhipeng. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var play_button: PressableButton!
    @IBOutlet weak var rule_button: FlatButton!
    @IBOutlet var play_view: UIView!
    @IBOutlet weak var setting_button: FlatButton!
    
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //change UIview background
        let bg_color = UIColor(red: 19/255, green: 38/255, blue: 51/255, alpha: 1.0)
        self.play_view.backgroundColor = bg_color
        
        let color1 = UIColor(red: 236/255, green: 74/255, blue: 66/255, alpha: 1.0)
        let color2 = UIColor(red: 196/255, green: 55/255, blue: 48/255, alpha: 1.0)
        let color3 = UIColor(red: 117/255, green: 145/255, blue: 247/255, alpha: 1.0)
        let color4 = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1.0)
        
        play_button.setTitleColor(UIColor.white, for: .normal)
        play_button.colors = .init(button: color1, shadow: color2)
        //play_button.disabledColors = .init(button: color1, shadow: color1)
        play_button.shadowHeight = 10
        play_button.cornerRadius = 8
        play_button.depth = 0.5 // In percentage of shadowHeight
        
        rule_button.setTitleColor(UIColor.white, for: .normal)
        rule_button.color = color3
        rule_button.highlightedColor = color3
        rule_button.selectedColor = .blue
        rule_button.cornerRadius = 8
        
        setting_button.setTitleColor(UIColor.white, for: .normal)
        setting_button.color = color4
        setting_button.highlightedColor = color4
        setting_button.selectedColor = .blue
        setting_button.cornerRadius = 8
        
        //Google Ads banner view
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.frame = CGRect(x: 0.0,
                                  y: UIApplication.shared.statusBarFrame.size.height,
                                  width: bannerView.frame.width,
                                  height: bannerView.frame.height)
        self.view.addSubview(bannerView)
        bannerView.adUnitID = "ca-app-pub-5562078941559997/9122934955"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        let requestAd: GADRequest = GADRequest()
        requestAd.testDevices = [kGADSimulatorID]
        bannerView.load(requestAd)
    }
}
