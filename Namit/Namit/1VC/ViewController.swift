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

    @IBOutlet weak var play_button: UIButton!
    @IBOutlet weak var rule_button: UIButton!
    @IBOutlet var play_view: UIView!
    @IBOutlet weak var setting_button: UIButton!
    
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //change UIview background
        let bg_color = UIColor(red: 19/255, green: 38/255, blue: 51/255, alpha: 1.0)
        self.play_view.backgroundColor = bg_color
        
        let color1 = UIColor(red: 236/255, green: 74/255, blue: 66/255, alpha: 1.0)
//        let color2 = UIColor(red: 196/255, green: 55/255, blue: 48/255, alpha: 1.0)
//        let color3 = UIColor(red: 117/255, green: 145/255, blue: 247/255, alpha: 1.0)
//        let color4 = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1.0)
        
        //customize play button
        play_button.clipsToBounds = true
        play_button.layer.borderWidth = 5.0
        play_button.layer.borderColor = color1.cgColor
        play_button.layer.cornerRadius = 0.5 * play_button.bounds.size.width
        play_button.setTitleColor(UIColor.white, for: .normal)
        //kerning play_button's title
        let attributedString = NSMutableAttributedString(string: "PLAY")
        attributedString.addAttribute(NSAttributedStringKey.kern, value: 15, range: NSRange(location: 0, length: attributedString.length - 1))
        play_button.titleLabel?.attributedText = attributedString

        //customize rule button
        //rule_button.clipsToBounds = true
        rule_button.layer.borderWidth = 3.0
        rule_button.layer.borderColor = UIColor.white.cgColor
        rule_button.layer.cornerRadius = 5
        rule_button.setTitleColor(UIColor.white, for: .normal)
        let rule_attributedString = NSMutableAttributedString(string: "RULES")
        rule_attributedString.addAttribute(NSAttributedStringKey.kern, value: 3, range: NSRange(location: 0, length: rule_attributedString.length - 1))
        rule_button.titleLabel?.attributedText = rule_attributedString

        
        
        let white = UIColor(red: 148/255, green: 149/255, blue: 156/255, alpha: 1.0)
        setting_button.setTitleColor(white, for: .normal)
        setting_button.setTitle(GoogleIcon.icons()[196], for: .normal)
        setting_button.backgroundColor = UIColor.clear
        
        //Google Ads banner view
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.frame = CGRect(x: 0.0,
//                                  y: UIApplication.shared.statusBarFrame.size.height, //under the status bar
                                  y: view.frame.size.height - bannerView.frame.height, //bottom of the view
                                  width: bannerView.frame.width,
                                  height: bannerView.frame.height)
        self.view.addSubview(bannerView)
//        bannerView.adUnitID = "ca-app-pub-5562078941559997/8772933204"
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"

        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        let requestAd: GADRequest = GADRequest()
        requestAd.testDevices = [kGADSimulatorID]
        
        requestAd.testDevices = ["c5825252428348a3b99ab1e2919f0337" ]

        bannerView.load(requestAd)
    }
    
    
}

