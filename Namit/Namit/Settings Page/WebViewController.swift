//
//  WebViewController.swift
//  Namit
//
//  Created by Adrian on 3/22/18.
//  Copyright © 2018 Mei. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var back_button: UIImageView!
    @IBOutlet weak var webView: WKWebView!
    var myurl: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: myurl)
        webView.load(URLRequest(url: url!))
        
        //UIImage tapped
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        back_button.isUserInteractionEnabled = true
        back_button.addGestureRecognizer(tapGestureRecognizer)

    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.dismiss(animated: false, completion: nil)
    }

}
