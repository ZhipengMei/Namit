//
//  ViewController.swift
//  playerSelection_collectionView
//
//  Created by Adrian on 3/15/18.
//  Copyright © 2018 Mei. All rights reserved.
//

import UIKit
import CoreData

class CollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var emoji_label: UILabel!
}

class PlayerSelectionView: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var moreCharLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myview: UIView!
    @IBOutlet weak var back_imageview: UIImageView!
    
    
    let reuseIdentifier = "collectionViewCellId"
    let context = CoreDataHelper().managedObjectContext()
    // Create Fetch Request
    var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Players")
    //placeholder for coredata
    var available_players = [Players]()
    var selected_players = [Players]()
    
    let darkColor = UIColor(red: 31/255, green: 41/255, blue: 64/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkplayercount()
        myview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        
        setupLayout()
        available_players = CoreDataHelper().fetch(context: context, entityName: "Players", sortDescriptorKey: "row", selected: 0, isPredicate: false) as! [Players]
        selected_players = CoreDataHelper().fetch(context: context, entityName: "Players", sortDescriptorKey: "selected_row", selected: 1, isPredicate: true) as! [Players]
        
        
        //UIImage tapped
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        back_imageview.isUserInteractionEnabled = true
        back_imageview.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("Hi lalalalal back btn")
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}



/* ========= Talbe view ========= */
extension PlayerSelectionView: UITableViewDataSource, UITableViewDelegate {
    
    // sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selected_players.count > 0 { return selected_players.count }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        if selected_players.count > 0 {
            configureCell(cell, at: indexPath)
        }
        return cell
    }
    
    
    private func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        
        //table cell
        let player = selected_players[indexPath.row]
        cell.textLabel?.text = "\(player.name!) Player \(player.selected_row + 1)"
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "Viga", size: 17)
        cell.backgroundColor = darkColor
        
    }
    
    //allow cell to rearrange
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //position did not change
        if sourceIndexPath == destinationIndexPath {
            return
        }
        
        //swap position, "row" maintains the order of selected players
        let source_player = selected_players[sourceIndexPath.row]
        
        //for UI animation
        selected_players.remove(at: sourceIndexPath.row)
        selected_players.insert(source_player, at: destinationIndexPath.row)
        assignOrder()
        try! context.save() //save
        tableView.reloadData() //refresh the tableview
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            print("Delete clicked")
            
            let player = selected_players[indexPath.row]
            player.selected = 0
            //reassign collection view's player.selected value to 1
            
            selected_players.remove(at: indexPath.row)
            assignOrder()
            
            try! context.save()
            tableView.reloadData()
            collectionView.reloadData()
        }
    }
    
    //re-order the selected players only
    func assignOrder() {
        for (i, player) in selected_players.enumerated() {
            player.selected_row = Int16(i)            
        }
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
}
/* ========= End Table view ========= */







/* ========= Collection view ========= */
extension PlayerSelectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return available_players.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        //cell.imageView.backgroundColor = UIColor.randomColor()
        cell.emoji_label.text = available_players[indexPath.row].name
        //yee
        if available_players[indexPath.row].selected == 1 {
            print(available_players[indexPath.row].name!)
            print(available_players[indexPath.row].selected)
            cell.layer.cornerRadius = cell.frame.height / 2
            cell.layer.borderWidth = 3.0
            cell.layer.borderColor = (UIColor.white).cgColor
        } else {
            cell.layer.cornerRadius = 0
            cell.layer.borderWidth = 0
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        let player = available_players[indexPath.row]
        
        //customize UI when clicked
        if player.selected == 0 {
            //add player emoji into tableview
            player.selected = 1
            selected_players.insert(player, at: selected_players.count)
        } else if player.selected == 1 {
            //yee

            //remove player emoji from tableview
            player.selected = 0
            selected_players.remove(at: Int(player.selected_row))
        }
        checkplayercount()
        assignOrder()
        try! context.save()
        collectionView.reloadData()
        tableView.reloadData()
        //auto scroll to the bottom of the tableview
        tableViewScrollToBottom(animated: true)
    }
    
    private func checkplayercount() {
        if selected_players.count < 2 {
            navigationController?.navigationBar.isUserInteractionEnabled = false
            descriptionLabel.text = "Add at least 2 players."
            //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(GoToBack))
        } else {
            navigationController?.navigationBar.isUserInteractionEnabled = true
            descriptionLabel.text = "You can add, remove, change orders of characters."
        }
    }
    
}
/* ========= End Collection view ========= */









/* ========= Support ========= */
extension PlayerSelectionView {
    
    //setup the UI components (cover partially on size, color, position, etc...)
    private func setupLayout() {
        
        //view
        view.backgroundColor = darkColor
        
        //navigationController
        navigationItem.title = "Player Setting"
        navigationController?.navigationBar.barTintColor = UIColor(red: 24/255, green: 32/255, blue: 51/255, alpha: 1)//UIColor(red: 0, green: 0, blue: 0, alpha: 0.21)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        
        //description label
        descriptionLabel.text = "You can add, remove, change orders of characters."
        descriptionLabel.font = UIFont(name: "Viga", size: 17)
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = true
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .white
        descriptionLabel.backgroundColor = darkColor
        
        // playerLabel
        playerLabel.textAlignment = .center
        playerLabel.text = "PLAYERS"
        playerLabel.backgroundColor = darkColor
        playerLabel.font = UIFont(name: "Viga", size: 12)
        
        // tableview
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = darkColor//UIColor(red: 0, green: 0, blue: 0, alpha: 0.21)
        tableView.isEditing = true //enable editing
        
        //more characters
        moreCharLabel.backgroundColor = UIColor.clear
        moreCharLabel.textAlignment = .center
        moreCharLabel.font = UIFont(name: "Viga", size: 12)
        
        //collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear//(red: 0, green: 0, blue: 0, alpha: 0.25)
        collectionView.indicatorStyle = .white
    }
}
/* ========= End Support ========= */

