//
//  settingVC.swift
//  Namit
//
//  Created by Adrian on 2/3/18.
//  Copyright © 2018 Mei. All rights reserved.
//

import UIKit

class settingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {    

    @IBOutlet weak var tableview: UITableView!
    private var data:[String] = ["Edit Cards", "Edit Penalties", "Interval time", "Sound", "Remove Ads", "Privacy Policy", "Share with Friends"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        tableview.delegate = self
        
        self.title = "Settings"
        
        // optional colors
        self.tableview.backgroundColor = UIColor.purple
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_reuse_identifier")
        let text = data[indexPath.row]
        cell?.textLabel?.text = text
        
        // optional color
        cell?.backgroundColor = UIColor.yellow
        
        return cell!
    }

    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
}


//// extension by Paul Hudson
//extension UIColor {
//    public convenience init?(hexString: String) {
//        let r, g, b, a: CGFloat
//
//        if hexString.hasPrefix("#") {
//            let start = hexString.index(hexString.startIndex, offsetBy: 1)
//            let hexColor = String(hexString[start...])
//
//            if hexColor.count == 8 {
//                let scanner = Scanner(string: hexColor)
//                var hexNumber: UInt64 = 0
//
//                if scanner.scanHexInt64(&hexNumber) {
//                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
//                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
//                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
//                    a = CGFloat(hexNumber & 0x000000ff) / 255
//
//                    self.init(red: r, green: g, blue: b, alpha: a)
//                    return
//                }
//            }
//        }
//
//        return nil
//    }
//}

