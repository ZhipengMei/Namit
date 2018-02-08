//
//  DetailTableView.swift
//  tableview_example
//
//  Created by Adrian on 2/6/18.
//  Copyright © 2018 Mei. All rights reserved.
//

import UIKit
import CoreData

class detailTableView: UIViewController {
    
    private var detailTableView: UITableView!
    //private var data: [String] = []

    // optional string to receive data from settingVC
    var passedData: String?
    
    //default variable for NSFetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: passedData!)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // change the view title
        self.navigationItem.title = passedData!
        
        // preparing tableview's size and position
        let barHeigh: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // setup tableview programmatically
        detailTableView = UITableView(frame: CGRect(x: 0, y: barHeigh, width: displayWidth, height: displayHeight - barHeigh))
        detailTableView.register(UITableViewCell.self, forCellReuseIdentifier: "detailCell")
        detailTableView.dataSource = self
        detailTableView.delegate = self
        self.view.addSubview(detailTableView)
        
        //self.detailTableView.separatorStyle = .none
        
        // fetching coreData
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Save Note")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
    }
    
}


// implementatio of tableview
extension detailTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("haha  -- ")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let row_count = self.fetchedResultsController.fetchedObjects?.count {
            return row_count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath as IndexPath)
        configureCell(cell, at: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        
        var content: Any
        
        if passedData! == "Cards" {
            content = fetchedResultsController.object(at: indexPath) as! Cards
        } else {
            content = fetchedResultsController.object(at: indexPath) as! Punishments
        }
        cell.textLabel?.text = (content as AnyObject).name
        // label displays multiple lines
        cell.textLabel?.numberOfLines = 0
    }
    
    // enable swipable on tableview
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.delete_alertView(indexPath: indexPath)
        }
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            self.edit_alertView(indexPath: indexPath)
        }
        
        edit.backgroundColor = UIColor.lightGray
        
        return [delete, edit]
        
    }
    
    //alert view for deleting object
    func delete_alertView(indexPath: IndexPath) {
        // tableview must contain at least 3 items
        // delete an item and update coreData
        if (self.fetchedResultsController.fetchedObjects?.count)! > 3 {
            
            // Fetch item
            let item = self.fetchedResultsController.object(at: indexPath)
            
            // Delete item
            self.fetchedResultsController.managedObjectContext.delete(item as! NSManagedObject)
            // Save Changes
            do {
                try self.fetchedResultsController.managedObjectContext.save()
            } catch {
                print("Error: cannot save after deletion")
            }
        } else {
            // Display an alert message to user
            //1. Create the alert controller.
            let alertController = UIAlertController(title: "Warning", message: "More cards = More fun", preferredStyle: .alert)
            //2. Cancel action
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [] (_) in }))
            //3. Present the alert.
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    //alert view for editing object
    func edit_alertView(indexPath: IndexPath) {
        //1. Create the alert controller.
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        var fetchObject: Any
        if passedData! == "Cards" {
            fetchObject = fetchedResultsController.object(at: indexPath) as! Cards
        } else {
            fetchObject = fetchedResultsController.object(at: indexPath) as! Punishments
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
            
            if self.passedData! == "Cards" {
                (fetchObject as! Cards).name = textField?.text!
            } else {
                (fetchObject as! Punishments).name = textField?.text!
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
    
}


// implementatio of NSFetchedResultsController
extension detailTableView: NSFetchedResultsControllerDelegate {
    
    //default for NSFetchedResultsController
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        detailTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        detailTableView.endUpdates()
    }
    
    //default for NSFetchedResultsController
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                detailTableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                detailTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = detailTableView.cellForRow(at: indexPath) {
                configureCell(cell, at: indexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                detailTableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                detailTableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
    }
}
