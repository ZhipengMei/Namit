//
//  FruitsTableViewController.swift
//  TableExample
//
//  Created by Ralf Ebert on 27.11.17.
//  Copyright © 2017 Example. All rights reserved.
//

import UIKit
import CoreData

class CardsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    public var context: NSManagedObjectContext!
    var row: Int?
    var viewTitle: String?
    
    // MARK: -
    //default for NSFetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.viewTitle!)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(viewTitle!)
        
        // title
        self.navigationItem.title = self.viewTitle!
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        //set view background color
        self.tableView.backgroundColor = UIColor(red: 19/255, green: 38/255, blue: 51/255, alpha: 1.0)
        
        //chage separatorColor
        let separatorColor = UIColor(red: 46/255, green: 48/255, blue: 48/255, alpha: 1.0)
        self.tableView.separatorColor = separatorColor
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Save Note")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        self.tableView.separatorStyle = .none

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.fetchedResultsController.fetchedObjects?.count {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        // Configure Cell
        configureCell(cell, at: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        // Fetch Cards
        var content: Any

        if row! == 0 {
            content = fetchedResultsController.object(at: indexPath) as! Cards
        } else {
            content = fetchedResultsController.object(at: indexPath) as! Penalties
        }
        
        
        // Configure Cell
        let color1 = UIColor(red: 19/255, green: 38/255, blue: 51/255, alpha: 1.0)
        cell.backgroundColor = color1
        cell.textLabel?.text = (content as AnyObject).name
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.text = ""
        cell.selectionStyle = .none
//        cell.imageView?.image = UIImage(named: fruitName)
    }
    
    //default for NSFetchedResultsController
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //default for NSFetchedResultsController
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
                configureCell(cell, at: indexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
    }
    
    // enable swipable on tableview
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in

            if (self.fetchedResultsController.fetchedObjects?.count)! > 3 {

                // Fetch card
                let card = self.fetchedResultsController.object(at: indexPath)
                
                // Delete card
                self.fetchedResultsController.managedObjectContext.delete(card as! NSManagedObject)
                // Save Changes
                do {
                    try self.fetchedResultsController.managedObjectContext.save()
                } catch {
                    print("Error: cannot save after deletion")
                }
            } else {
                //1. Create the alert controller.
                let alertController = UIAlertController(title: "Warning", message: "More cards = More fun", preferredStyle: .alert)
                //2. Cancel action
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [] (_) in }))
                //3. Present the alert.
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            self.alerView(indexPath: indexPath)
        }
        
        edit.backgroundColor = UIColor.lightGray
        
        return [delete, edit]
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.alerView(indexPath: indexPath)
    }
    
    //alert view for updating object
    func alerView(indexPath: IndexPath) {
        //1. Create the alert controller.
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        var fetchObject: Any
        
        if row! == 0 {
            fetchObject = fetchedResultsController.object(at: indexPath) as! Cards
        } else {
            fetchObject = fetchedResultsController.object(at: indexPath) as! Penalties
        }
        
        //2. Add the text field. You can configure it however you need.
        alertController.addTextField { (textField) in
            textField.text = (fetchObject as AnyObject).name
        }
        
        // Cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [] (_) in }))
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alertController] (_) in
            let textField = alertController?.textFields![0] // Force unwrapping because we know it exists.
            //print("Text field: \(String(describing: textField?.text!))")
            
            if self.row! == 0 {
                (fetchObject as! Cards).name = textField?.text!
            } else {
                (fetchObject as! Penalties).name = textField?.text!
            }
            
            do{
                try (fetchObject as AnyObject).managedObjectContext?.save()
            } catch {
                print("error")
            }
        }))
        
        // 4. Present the alert.
        present(alertController, animated: true, completion: nil)
    }
    
//    func configFetchObject(){
//
//    }
    @IBAction func addCard(_ sender: Any) {
        
        //1. Create the alert controller.
        var word:String
        if self.row! == 0 {
            word = "card"
        }else{
            word = "penalty"
        }
        let addAlertController = UIAlertController(title: "Add a new \(word)", message: "", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        addAlertController.addTextField { (textField) in
            textField.text = ""
        }
        
        // Cancel action
        addAlertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [] (_) in }))
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        addAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak addAlertController] (_) in
            let text = addAlertController?.textFields![0].text // Force unwrapping because we know it exists.

            print(text!)
            // add to coreData
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            if self.row! == 0 {
                let card_entity = NSEntityDescription.entity(forEntityName: "Cards", in: context)
                let newCard = NSManagedObject(entity: card_entity!, insertInto: context)
                newCard.setValue(text!, forKey: "name")
            } else {
                let Penalties_entity = NSEntityDescription.entity(forEntityName: "Penalties", in: context)
                let newCard = NSManagedObject(entity: Penalties_entity!, insertInto: context)
                newCard.setValue(text!, forKey: "name")
            }

//            do {
//                try context.save()
//                print("Cards entity saved")
//            } catch {
//                print("Failed saving")
//            }

        }))
        
        // 4. Present the alert.
        present(addAlertController, animated: true, completion: nil)
        
    }
    
}
