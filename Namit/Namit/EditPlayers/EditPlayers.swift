//
//  ViewController.swift
//  PlayerSelection_Example
//
//  Created by Adrian on 2/27/18.
//  Copyright © 2018 Mei. All rights reserved.
//

import UIKit
import CoreData

class EditPlayers: UIViewController {

    let sections = ["Players", "More Characters"]
    private var myTableView: UITableView!
    
    // coredata variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selected_players = [Players]()
    var available_players = [Players]()
    
    // Create Fetch Request
    var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Players")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController
        navigationItem.title = "Player Setting"
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false

        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        //let navBarHeight: CGFloat = (self.navigationController?.navigationBar.frame.height)!
        
        //setup label
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: displayWidth, height: 70))
        label.textAlignment = .center
        label.text = "You can add, remove, change orders of characters."
        label.translatesAutoresizingMaskIntoConstraints = true
        label.numberOfLines = 0
        label.textColor = .white
        label.backgroundColor = .black
        self.view.addSubview(label)
        
        //setup tableview
        myTableView = UITableView(frame: CGRect(x: 0, y: label.frame.height, width: displayWidth, height: displayHeight - barHeight))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.separatorStyle = .singleLine
        myTableView.backgroundColor = .black
        //enable editing
        myTableView.isEditing = true
        self.view.addSubview(myTableView)
        
        do {
            fetchRequest.predicate = NSPredicate(format: "section == %d", 0)
            // Add Sort Descriptor
            let sortDescriptor = NSSortDescriptor(key: "row", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            selected_players = try! context.fetch(fetchRequest) as! [Players]

            fetchRequest.predicate = NSPredicate(format: "section == %d", 1)
            available_players = try! context.fetch(fetchRequest) as! [Players]
        }
        
    }

}

// Tableview Delegate and DataSource
extension EditPlayers: UITableViewDelegate, UITableViewDataSource {
    
    // Section count
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // Section Title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    //Row count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return selected_players.count
        } else if section == 1 {
            return available_players.count
        }
        return 0
    }
    
    //header view
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.black
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        configureCell(cell, at: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor.black
        cell.textLabel?.font = cell.textLabel?.font.withSize(20)
        if indexPath.section == 0 {
            let player = selected_players[indexPath.row]
            cell.textLabel?.text = "\(player.name!)   Player \(player.row + 1)"
        } else if indexPath.section == 1 {
            cell.textLabel?.text = available_players[indexPath.row].name
        }
    }

    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    {
        if indexPath.section == 0
        {
            return .delete
        }
        else if indexPath.section == 1
        {
            return .insert
        }
        return .none
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete && indexPath.section == 0
        {
            let item = selected_players[indexPath.row]
            item.section = 1
            selected_players.remove(at: indexPath.row)
            available_players.insert(item, at: 0)
            assignOrder()
            try! context.save()
            myTableView.reloadData()
        }
        else if editingStyle == .insert && indexPath.section == 1
        {
            let item = available_players[indexPath.row]
            item.section = 0
            available_players.remove(at: indexPath.row)
            selected_players.insert(item, at: selected_players.count)
            assignOrder()
            try! context.save()
            myTableView.reloadData()
        }
    }
    
    func assignOrder() {
        for (i, object) in selected_players.enumerated() {
            object.row = Int16(i)
        }
    }
    
    //save re-order state
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        if sourceIndexPath == destinationIndexPath {
            return
        }

        //swap position
        let item = selected_players[sourceIndexPath.row]
        selected_players.remove(at: sourceIndexPath.row)
        selected_players.insert(item, at: destinationIndexPath.row)
        
        //re-assign orders
        assignOrder()
        try! context.save()
        myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool
    {
        return false
    }
    
    // enable only the first section can drag to move
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        if indexPath.section == 0 { return true }
        return false
    }
}// end extension
