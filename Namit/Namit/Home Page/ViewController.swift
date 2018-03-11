//
//  ViewController.swift
//  Namit
//
//  Created by Adrian on 2/2/18.
//  Copyright © 2018 Mei. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController {

    // buttons
    @IBOutlet weak var play_button: UIButton!
    @IBOutlet weak var setting_button: UIButton!
    @IBOutlet weak var rule_button: UIButton!
    @IBOutlet weak var setPlayer_button: UIButton!
    
    // labels
    @IBOutlet weak var setting_label: UILabel!
    @IBOutlet weak var rule_label: UILabel!
    
    // STEP 1: initialize ads banner view
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // play btn
        self.play_button.clipsToBounds = true
        self.play_button.backgroundColor = UIColor.red
        self.play_button.layer.cornerRadius = self.play_button.bounds.size.width * 0.5
        self.play_button.setTitleColor(UIColor.white, for: .normal)
        //kerning
        let attributedString = NSMutableAttributedString(string: "PLAY")
        attributedString.addAttribute(NSAttributedStringKey.kern, value: 15, range: NSRange(location: 0, length: attributedString.length - 1))
        self.play_button.titleLabel?.attributedText = attributedString
        //font and size
        self.play_button.titleLabel?.font =  UIFont(name: "helvetica neue", size: 20)
        
        // edit players
        self.setPlayer_button.layer.cornerRadius = self.setPlayer_button.bounds.height / 2
        
        // setting btn
        self.setting_button.backgroundColor = UIColor.red
        self.setting_button.layer.cornerRadius = self.setting_button.bounds.size.width * 0.5
        self.setting_button.setTitleColor(UIColor.white, for: .normal)
        
        // rule btn
        self.rule_button.backgroundColor = UIColor.red
        self.rule_button.layer.cornerRadius = self.rule_button.bounds.size.width * 0.5
        self.rule_button.setTitleColor(UIColor.white, for: .normal)
        
        // setting label
        setting_label.textColor = UIColor.white
        setting_label.backgroundColor = .black
        
        //rule label
        rule_label.textColor = UIColor.white
        rule_label.backgroundColor = .black
        
        // view
        self.view.backgroundColor = UIColor.black
        
        
        // Google AdMob
        // Instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-5562078941559997/8772933204"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        addBannerViewToView(bannerView)
        bannerView.delegate = self
        
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
    
    @IBAction func toEditPlayers(_ sender: Any) {
        self.navigationController?.pushViewController(EditPlayers(), animated: true)
    }
    
    
    

}


extension ViewController: GADBannerViewDelegate {
    
    // ============ GADBannerViewDelegate Methods ===================================================================
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        // Animating a banner ad
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    // ==========/GADBannerViewDelegate Methods=========================================
 
    
    
    // ========================= Smart Banners ========================================================
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            // In iOS 11, we need to constrain the view to the safe area.
            positionBannerViewFullWidthAtBottomOfSafeArea(bannerView)
        }
        else {
            // In lower iOS versions, safe area is not available so we use
            // bottom layout guide and view edges.
            positionBannerViewFullWidthAtBottomOfView(bannerView)
        }
    }
    
    // MARK: - view positioning
    @available (iOS 11, *)
    func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
        // Position the banner. Stick it to the bottom of the Safe Area.
        // Make it constrained to the edges of the safe area.
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
            guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
            ])
    }
    
    func positionBannerViewFullWidthAtBottomOfView(_ bannerView: UIView) {
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: 0))
        view.addConstraint(NSLayoutConstraint(item: bannerView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: view.safeAreaLayoutGuide.bottomAnchor,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 0))
    }
    // ===================== /Smart Banners ============================================================
}

