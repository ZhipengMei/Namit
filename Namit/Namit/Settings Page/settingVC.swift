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
    private var data:[String] = ["Edit Cards", "Edit Punishments", "Interval time", "Sound", "Remove Ads", "Privacy Policy", "Share with Friends"]
    
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
        cell?.selectionStyle = .none

        if indexPath.row == 0 || indexPath.row == 1{
            // cell right arrow
            cell?.accessoryType = .disclosureIndicator
        }

        if indexPath.row == 2 {
            // UISwitch setup
            let interval_label = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 20))
            interval_label.backgroundColor = UIColor.blue
            interval_label.text = "5 seconds"
            interval_label.textAlignment = .center
            interval_label.textColor = .white
            cell?.accessoryView = interval_label as UIView
        }
        
        if indexPath.row == 3 {
            // UISwitch setup
            let sound_switch = UISwitch(frame: CGRect(x: 10, y: 10, width: 100, height: 20))
            sound_switch.backgroundColor = .green
            sound_switch.setOn(true, animated: true)
            sound_switch.addTarget(self, action: #selector(sound_switch_action), for: .touchUpInside)
            cell?.accessoryView = sound_switch as UIView
        }

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var dataToPass: String?
        // parse the string to obtain valid CoreData Entity name
        if (data[indexPath.row]).range(of:"Cards") != nil {
            dataToPass = "Cards"
        }
        if (data[indexPath.row]).range(of:"Punishments") != nil {
            dataToPass = "Punishments"
        }
        
        let detail_TableView = detailTableView()
        detail_TableView.passedData = dataToPass!
        self.navigationController?.pushViewController(detail_TableView, animated: true)
    }

    @objc func sound_switch_action() {
        print("clicked")
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
}

