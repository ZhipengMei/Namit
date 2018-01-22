//
//  CardVC.swift
//  NameIt
//
//  Created by Adrian on 12/27/17.
//  Copyright © 2017 zhipeng. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

class CardVC: UIViewController, NSFetchedResultsControllerDelegate, GADBannerViewDelegate, GADNativeAppInstallAdLoaderDelegate,
GADNativeContentAdLoaderDelegate, GADVideoControllerDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var card_label: UILabel!
    @IBOutlet weak var punishment_button: UIButton!
    @IBOutlet var card_vc_view: UIView!
    @IBOutlet weak var cancel_button: FlatButton!
    
    public var context: NSManagedObjectContext!
    var previous_index = 0
    var bannerView: GADBannerView!
//    let Card_Content_View = Bundle.main.loadNibNamed("Card_Content", owner: self, options: nil)?.first as! Card_Content

    // MARK: -
    //default for NSFetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    /// The ad loader that loads the native ads.
    /// The ad loader. You must keep a strong reference to the GADAdLoader during the ad loading
    /// process.
    var adLoader: GADAdLoader!
    
    /// The native ad view that is being presented.
    var nativeAdView: UIView?
    
    /// The ad unit ID.
    let adUnitID = "ca-app-pub-3940256099942544/3986624511"

    @IBOutlet weak var nativeAdPlaceholder: UIView!
    @IBOutlet weak var closeAd_button: FlatButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Save Note")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }

        //change UIview background
        let bg_color = UIColor(red: 19/255, green: 38/255, blue: 51/255, alpha: 1.0)
        self.card_vc_view.backgroundColor = bg_color

        let indexPath = IndexPath(row: previous_index, section: 0)
        let card = fetchedResultsController.object(at: indexPath) as! Cards
        card_label.textColor = UIColor.white

        self.punishment_button.layer.cornerRadius = 10
        self.punishment_button.backgroundColor = UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 0.5)

        self.cardView.layer.cornerRadius = 10
        self.cardView.backgroundColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.00)

        //modify cancel button
        let color = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1.0)
        cancel_button.setTitleColor(UIColor.white, for: .normal)
        cancel_button.color = color
        cancel_button.highlightedColor = color
        cancel_button.selectedColor = .blue
        cancel_button.cornerRadius = 8
        
        // Mark Google Ads banner view
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
        // END banner view
        
        //show a card
        show_next_card()
//        fadein_effect()
        
        refreshAd()
        nativeAdPlaceholder.isHidden = true
        closeAd_button.isHidden = true
    }
    
    //tap action to display message content
    @IBAction func tapAction(_ sender: Any) {
        show_next_card()
    }
    
    //display and randomized cards order
    var cardCount = 0
    var cardObj: [Cards] = []
    func show_next_card() {
        if cardCount > 0 && cardCount < (fetchedResultsController.fetchedObjects?.count)! {
            //let indexPath = IndexPath(row: cardCount, section: 0)
            if cardCount % 10 == 0 { //every other 10 card shows an ad
                cardView.isHidden = true
                cancel_button.isHidden = true
                nativeAdPlaceholder.isHidden = false
                closeAd_button.isHidden = false
            }
            card_label.text = cardObj[cardCount].name!
            cardCount += 1
        } else if cardCount == 0 || cardCount >= (fetchedResultsController.fetchedObjects?.count)! {
            cardObj = fetchedResultsController.fetchedObjects as! [Cards]
            cardObj.shuffle()
            cardCount = 1
            show_next_card()
        }

        //flip UIView animation
        UIView.transition(with: cardView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    @IBAction func cancel_button_cation(_ sender: Any) {
        cardCount = 0
        dismiss(animated: true, completion: nil)
    }
    
//    func fadein_effect() {
//        self.card_label.alpha = 0
//        self.punishment_button.alpha = 0
//
//        //fade in animation
//        UIView.animate(withDuration: 1.5,
//                       delay: 0.5,
//                       usingSpringWithDamping: 0.3,
//                       initialSpringVelocity: 0.5,
//                       options: [], animations: {
//                        self.card_label.alpha = 1 },
//                       completion: nil)
//
//        UIView.animate(withDuration: 2.0,
//                       delay: 0.5,
//                       usingSpringWithDamping: 0.3,
//                       initialSpringVelocity: 0.5,
//                       options: [], animations: {
//                        self.punishment_button.alpha = 1 },
//                       completion: nil)
//    }
    
    // Mark: - GADNativeAppInstallAdLoaderDelegate
    func setAdView(_ view: UIView) {
        // Remove the previous ad view.
        nativeAdView?.removeFromSuperview()
        nativeAdView = view
        nativeAdPlaceholder.addSubview(nativeAdView!)
        nativeAdView!.translatesAutoresizingMaskIntoConstraints = false
        
        // Layout constraints for positioning the native ad view to stretch the entire width and height
        // of the nativeAdPlaceholder.
        let viewDictionary = ["_nativeAdView": nativeAdView!]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[_nativeAdView]|",
                                                                options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[_nativeAdView]|",
                                                                options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
    }
    
    /// Refreshes the native ad.
    func refreshAd() {
        var adTypes = [GADAdLoaderAdType]()
        adTypes.append(GADAdLoaderAdType.nativeAppInstall)
        adTypes.append(GADAdLoaderAdType.nativeContent)
        
        adLoader = GADAdLoader(adUnitID: adUnitID, rootViewController: self,
                               adTypes: adTypes, options: nil)
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
    
    // MARK: - GADAdLoaderDelegate
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
    
    // Mark: - GADNativeAppInstallAdLoaderDelegate
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAppInstallAd: GADNativeAppInstallAd) {
        print("Received native app install ad: \(nativeAppInstallAd)")
        
        // Create and place the ad in the view hierarchy.
        let appInstallAdView = Bundle.main.loadNibNamed("NativeAppInstallAdView", owner: nil,
                                                        options: nil)?.first as! GADNativeAppInstallAdView
        setAdView(appInstallAdView)
        
        // Associate the app install ad view with the app install ad object. This is required to make
        // the ad clickable.
        appInstallAdView.nativeAppInstallAd = nativeAppInstallAd
        
        // Populate the app install ad view with the app install ad assets.
        // Some assets are guaranteed to be present in every app install ad.
        (appInstallAdView.headlineView as! UILabel).text = nativeAppInstallAd.headline
        (appInstallAdView.iconView as! UIImageView).image = nativeAppInstallAd.icon?.image
        (appInstallAdView.bodyView as! UILabel).text = nativeAppInstallAd.body
        (appInstallAdView.callToActionView as! UIButton).setTitle(
            nativeAppInstallAd.callToAction, for: UIControlState.normal)
        
        // Some app install ads will include a video asset, while others do not. Apps can use the
        // GADVideoController's hasVideoContent property to determine if one is present, and adjust
        // their UI accordingly.
        
        // The UI for this controller constrains the image view's height to match the media view's
        // height, so by changing the one here, the height of both views are being adjusted.
        if (nativeAppInstallAd.videoController.hasVideoContent()) {
            
            // The video controller has content. Show the media view.
            appInstallAdView.mediaView?.isHidden = false
            appInstallAdView.imageView?.isHidden = true
            
            // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
            // ratio of the video it displays.
            let heightConstraint = NSLayoutConstraint(
                item: appInstallAdView.mediaView!,
                attribute: .height,
                relatedBy: .equal,
                toItem: appInstallAdView.mediaView!,
                attribute: .width,
                multiplier: CGFloat(1.0 / nativeAppInstallAd.videoController.aspectRatio()),
                constant: 0)
            heightConstraint.isActive = true
            
            // By acting as the delegate to the GADVideoController, this ViewController receives messages
            // about events in the video lifecycle.
            nativeAppInstallAd.videoController.delegate = self
            
        } else {
            // If the ad doesn't contain a video asset, the first image asset is shown in the
            // image view. The existing lower priority height constraint is used.
            appInstallAdView.mediaView?.isHidden = true
            appInstallAdView.imageView?.isHidden = false
            
            let firstImage: GADNativeAdImage? = nativeAppInstallAd.images?.first as? GADNativeAdImage
            (appInstallAdView.imageView as? UIImageView)?.image = firstImage?.image
            
        }
        
        // Other assets are not guaranteed to be present, and should be checked first.
        let starRatingView = appInstallAdView.starRatingView
        if let starRating = nativeAppInstallAd.starRating {
            (starRatingView as! UIImageView).image = imageOfStarsFromStarRating(starRating)
            starRatingView?.isHidden = false
        } else {
            starRatingView?.isHidden = true
        }
        
        let storeView = appInstallAdView.storeView
        if let store = nativeAppInstallAd.store {
            (storeView as! UILabel).text = store
            storeView?.isHidden = false
        } else {
            storeView?.isHidden = true
        }
        
        let priceView = appInstallAdView.priceView
        if let price = nativeAppInstallAd.price {
            (priceView as! UILabel).text = price
            priceView?.isHidden = false
        } else {
            priceView?.isHidden = true
        }
        
        // In order for the SDK to process touch events properly, user interaction should be disabled.
        (appInstallAdView.callToActionView as! UIButton).isUserInteractionEnabled = false
    }
    
    /// Returns a `UIImage` representing the number of stars from the given star rating; returns `nil`
    /// if the star rating is less than 3.5 stars.
    func imageOfStarsFromStarRating(_ starRating: NSDecimalNumber) -> UIImage? {
        let rating = starRating.doubleValue
        if rating >= 5 {
            return UIImage(named: "stars_5")
        } else if rating >= 4.5 {
            return UIImage(named: "stars_4_5")
        } else if rating >= 4 {
            return UIImage(named: "stars_4")
        } else if rating >= 3.5 {
            return UIImage(named: "stars_3_5")
        } else {
            return nil
        }
    }
    
    // Mark: - GADNativeContentAdLoaderDelegate
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeContentAd: GADNativeContentAd) {
        print("Received native content ad: \(nativeContentAd)")
        
        // Create and place the ad in the view hierarchy.
        let contentAdView = Bundle.main.loadNibNamed("NativeContentAdView", owner: nil,
                                                     options: nil)?.first as! GADNativeContentAdView
        setAdView(contentAdView)
        
        // Associate the content ad view with the content ad object. This is required to make the ad
        // clickable.
        contentAdView.nativeContentAd = nativeContentAd
        
        // Populate the content ad view with the content ad assets.
        // Some assets are guaranteed to be present in every content ad.
        (contentAdView.headlineView as! UILabel).text = nativeContentAd.headline
        (contentAdView.bodyView as! UILabel).text = nativeContentAd.body
        (contentAdView.imageView as! UIImageView).image =
            (nativeContentAd.images?.first as! GADNativeAdImage).image
        (contentAdView.advertiserView as! UILabel).text = nativeContentAd.advertiser
        (contentAdView.callToActionView as! UIButton).setTitle(
            nativeContentAd.callToAction, for: UIControlState.normal)
        
        // Other assets are not, however, and should be checked first.
        let logoView = contentAdView.logoView
        if let logoImage = nativeContentAd.logo?.image {
            (logoView as! UIImageView).image = logoImage
            logoView?.isHidden = false
        } else {
            logoView?.isHidden = true
        }
        
        // In order for the SDK to process touch events properly, user interaction should be disabled.
        (contentAdView.callToActionView as! UIButton).isUserInteractionEnabled = false
    }
    
    // Mark: - GADVideoControllerDelegate
    
    func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
        
    }
    
    @IBAction func close_Ad(_ sender: Any) {
        cardView.isHidden = false
        cancel_button.isHidden = false
        nativeAdPlaceholder.isHidden = true
        closeAd_button.isHidden = true
        refreshAd()
    }
    // //ads native advance END
    
}

/**
 Extend array to enable random shuffling
 */
extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
