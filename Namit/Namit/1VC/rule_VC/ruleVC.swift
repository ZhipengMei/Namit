//
//  ruleVC.swift
//  NameIt
//
//  Created by Adrian on 12/28/17.
//  Copyright © 2017 zhipeng. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ruleVC: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet var ruleVC_view: UIView!
    @IBOutlet weak var cancel_button: FlatButton!
    @IBOutlet weak var rule_textview: UITextView!
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //change UIview background
        let bg_color = UIColor(red: 19/255, green: 38/255, blue: 51/255, alpha: 1.0)
        ruleVC_view.backgroundColor = bg_color
        
        //modify textview
        rule_textview.layer.cornerRadius = 8
        
        //modify cancel button
        let color = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1.0)
        cancel_button.setTitleColor(UIColor.white, for: .normal)        
        cancel_button.color = color
        cancel_button.highlightedColor = color
        cancel_button.selectedColor = .blue
        cancel_button.cornerRadius = 8
        
        //Google Ads banner view
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.frame = CGRect(x: 0.0,
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
        bannerView.load(requestAd)
    }

}


