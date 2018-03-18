//
//  settingVC.swift
//  Namit
//
//  Created by Adrian on 2/3/18.
//  Copyright © 2018 Mei. All rights reserved.
//

import UIKit
import CoreData

class settingVC: UIViewController{

    @IBOutlet weak var tableview: UITableView!
    
    // initialize time interval label
    let interval_label = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 20))
    
    // values to fill table view
    private var data:[String] = ["Edit Cards", "Edit Punishments", "Interval time", "Sound", "Remove Ads", "Privacy Policy", "Share with Friends"]
    
    // initialize UIPickerView
    var time_interval_picker = UIPickerView()
    // values to fill picker view
    let time_interval: NSArray = ["3","4","5","6","7","8","9","10"]
    
    // core data request
    let time_fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameTimer")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //swithc
    var sound_switch = UISwitch()
    
    let darkColor = UIColor(red: 31/255, green: 41/255, blue: 64/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
        // set delegate
        time_interval_picker.delegate = self
        
        // set DataSource
        time_interval_picker.dataSource = self
        
        interval_label.font = UIFont(name: "Viga", size: 17)
        
        self.title = "Setting"
        
        // optional colors
        self.tableview.backgroundColor = darkColor
        
        // Eliminate extra separators below UITableView
        tableview.tableFooterView = UIView()
        
        
        // UIPickerView setup
            // set delegate
        time_interval_picker.delegate = self
            // set DataSource
        time_interval_picker.dataSource = self
        // set size
        time_interval_picker.frame = CGRect(x: 0, y: self.view.frame.size.height - self.time_interval_picker.frame.size.height, width: self.view.bounds.width, height:  self.view.frame.size.height * 0.4)
            // add it to view
        self.view.addSubview(time_interval_picker)
            // hide the pickerview
        time_interval_picker.alpha = 0
            // set background
        time_interval_picker.backgroundColor = .gray

    }

    // turn in game sound on/off
    @objc func sound_switch_action() {
        print("sound switch clicked")
        self.saveSoundBool(isSoundOn: sound_switch.isOn)
    }
    
    // convert RGB to hex color
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    func saveSoundBool(isSoundOn: Bool) {
        // retrieve the current coredata value then change it to new value.
        self.time_fetchRequest.returnsObjectsAsFaults = false
        self.time_fetchRequest.fetchLimit = 1
        do {
            let result = try context.fetch(time_fetchRequest) as! [GameTimer]
            if result.count == 1 {
                // retrieved data and update it
                result[0].soundOn = isSoundOn
                do{
                    try result[0].managedObjectContext?.save()
                } catch {
                    print("Error: saveTimerInterval")
                }
            }
        } catch {
            print("GameTimer: Retrieve data failed.")
        }
    }
    
    func saveTimerInterval(interval: Int16) {
        // retrieve the current coredata value then change it to new value.
        self.time_fetchRequest.returnsObjectsAsFaults = false
        self.time_fetchRequest.fetchLimit = 1
        do {
            let result = try context.fetch(time_fetchRequest) as! [GameTimer]
            if result.count == 1 {
                // retrieved data and update it
                result[0].interval = interval
                do{
                    try result[0].managedObjectContext?.save()
                } catch {
                    print("Error: saveTimerInterval")
                }
            }
        } catch {
            print("GameTimer: Retrieve data failed.")
        }
    }
    
    func getTimerInterval() -> Int {
        self.time_fetchRequest.returnsObjectsAsFaults = false
        self.time_fetchRequest.fetchLimit = 1
        do {
            let result = try context.fetch(time_fetchRequest) as! [GameTimer]
            if result.count == 1 {
                // return retrieved data
                return Int(result[0].interval)
            }
        } catch {
            print("GameTimer: Retrieve data failed.")
        }
        // default timer
        return 5
    }
    
    func getSound() -> Bool {
        self.time_fetchRequest.returnsObjectsAsFaults = false
        self.time_fetchRequest.fetchLimit = 1
        do {
            let result = try context.fetch(time_fetchRequest) as! [GameTimer]
            if result.count == 1 {
                // return retrieved data
                return result[0].soundOn
            }
        } catch {
            print("GameTimer: Retrieve data failed.")
        }
        // default soundOn
        return true
    }

}


extension settingVC: UITableViewDelegate, UITableViewDataSource {
    
    // ===================== tableView ============================================================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_reuse_identifier")
        let text = data[indexPath.row]
        cell?.textLabel?.text = text
        cell?.textLabel?.textColor = .white
        cell?.textLabel?.font = UIFont(name: "Viga", size: 17)
        
        // optional color
        cell?.backgroundColor = darkColor
        cell?.selectionStyle = .none
        
        
        if indexPath.row == 0 || indexPath.row == 1{
            // cell right arrow
            cell?.accessoryType = .disclosureIndicator
        }
        
        if indexPath.row == 2 {
            // Time Interval setup
            interval_label.backgroundColor = darkColor
            // display coredata's time interval
            interval_label.text = "\(self.getTimerInterval()) seconds"
            interval_label.textAlignment = .center
            interval_label.textColor = .white
            cell?.accessoryView = interval_label as UIView
        }
        
        if indexPath.row == 3 {
            // UISwitch setup
            sound_switch = UISwitch(frame: CGRect(x: 10, y: 10, width: 100, height: 20))
            sound_switch.backgroundColor = darkColor
            sound_switch.onTintColor = .red
            sound_switch.setOn(getSound(), animated: true)
            sound_switch.addTarget(self, action: #selector(sound_switch_action), for: .touchUpInside)
            cell?.accessoryView = sound_switch as UIView
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 || indexPath.row == 1{
            
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
        
        if indexPath.row == 2 {
            // display UIPickerView
            UIView.animate(withDuration: 0.3, animations: {
                self.time_interval_picker.alpha = 1
            })
        }
        
        if indexPath.row == 4 {
            print("clicked on Remove Ads")
        }
        
        if indexPath.row == 5 {
            print("clicked on Privacy policy")
        }
        
        if indexPath.row == 6 {
            print("clicked on Share with friends")
        }
        
        
    }
    // ===================== /tableView ============================================================
    
}


extension settingVC: UIPickerViewDelegate, UIPickerViewDataSource {

    // data method to return the number of column shown in the picker.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // data method to return the number of row shown in the picker.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return time_interval.count
    }
    
    // delegate method to return the value shown in the picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return time_interval[row] as? String
    }
    
    // delegate method called when the row was selected.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // display on the label
        self.interval_label.text = "\(time_interval[row]) seconds"
        self.interval_label.font = UIFont(name: "Viga", size: 17)
        // update coreData
        self.saveTimerInterval(interval: Int16((time_interval[row] as AnyObject).integerValue))
        
        // hide UIPickerView
        UIView.animate(withDuration: 0.3, animations: {
            self.time_interval_picker.alpha = 0
        })
    }
    
    // optional: modify text color
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let titleData = time_interval[row] as! String
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Viga", size: 27.0)!,NSAttributedStringKey.foregroundColor:UIColor.white])
        return myTitle

    }
    
    
}







