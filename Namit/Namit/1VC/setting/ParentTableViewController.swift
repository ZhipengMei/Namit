//
//  ParentTableViewController.swift
//  NameIt
//
//  Created by Adrian on 1/10/18.
//  Copyright © 2018 zhipeng. All rights reserved.
//

import UIKit

class ParentTableViewController: UITableViewController {
    
    let sectionLabel = ["Content"]
    let contentLabel = [["Cards", "Penalties"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // title
        self.navigationItem.title = "Settings"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        UINavigationBar.appearance().tintColor = UIColor.white

        
        //chage separatorColor
        let separatorColor = UIColor(red: 46/255, green: 48/255, blue: 48/255, alpha: 1.0)
        self.tableView.separatorColor = separatorColor
        
        //change navigationBar tintColor
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 19/255, green: 38/255, blue: 51/255, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent = true
        
        // change UIView bg color
        self.view.backgroundColor = UIColor(red: 19/255, green: 38/255, blue: 51/255, alpha: 1.0)

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionLabel.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.contentLabel[section].count
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionLabel[section]
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contentLabelCell", for: indexPath)

        // Configure the cell...
        let color1 = UIColor(red: 19/255, green: 38/255, blue: 51/255, alpha: 1.0)
        cell.backgroundColor = color1
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = contentLabel[indexPath.section][indexPath.row]
        cell.selectionStyle = .none

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if(segue.identifier == "toContent"){

            let row = (self.tableView.indexPathForSelectedRow?.row)!
            let controller = segue.destination as! CardsTableViewController
            
            controller.row = row
            
            switch row {
            case 0:
                controller.viewTitle = "Cards"
                break

            case 1:
                controller.viewTitle = "Penalties"
                break

            default:
                controller.viewTitle = "Cards"
                break
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }


    
}
