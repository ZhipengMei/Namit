//
//  DetailTableView.swift
//  tableview_example
//
//  Created by Adrian on 2/6/18.
//  Copyright © 2018 Mei. All rights reserved.
//

import UIKit
import CoreData
import SnapKit

class detailTableView: UIViewController {
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var btnVIew: UIView!
    @IBOutlet weak var addbutton: UIButton!
    @IBOutlet weak var editbutton: UIButton!
    @IBOutlet weak var back_imageview: UIImageView!
    
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
    
    var isEdit: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // change the view title
        self.navigationItem.title = passedData!
        detailTableView.dataSource = self
        detailTableView.delegate = self
    
        addbutton.layer.cornerRadius = addbutton.frame.height / 2
        addbutton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        addbutton.titleLabel?.font = UIFont(name: "Viga", size: 17)

        editbutton.layer.cornerRadius = editbutton.frame.height / 2
        editbutton.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        editbutton.titleLabel?.font = UIFont(name: "Viga", size: 17)
        
        // fetching coreData
        try! fetchedResultsController.performFetch()
        
        //UIImage tapped
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        back_imageview.isUserInteractionEnabled = true
        back_imageview.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func addAction(sender: UIButton!) {
        add_alertView()
    }
    
    @objc func editAction(sender: UIButton!) {
        if isEdit == false {
            isEdit = true
            detailTableView.isEditing = true //enable editing
            editbutton.setTitle("Done", for: .normal)
        } else {
            isEdit = false
            detailTableView.isEditing = false
            editbutton.setTitle("Edit", for: .normal)
        }
    }

    
}


// implementatio of tableview
extension detailTableView: UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEdit == true {
            self.edit_alertView(indexPath: indexPath)
        }
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
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor(red: 31/255, green: 41/255, blue: 64/255, alpha: 1)
        cell.selectionStyle = .none
        
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
    
    func edit_alertView(indexPath: IndexPath) {
        //prepare data for display
        var fetchObject: Any
        if passedData! == "Cards" {
            fetchObject = fetchedResultsController.object(at: indexPath) as! Cards
        } else {
            fetchObject = fetchedResultsController.object(at: indexPath) as! Punishments
        }
        
        let message = "Edit" + "\n\n\n\n\n\n\n"
        // textView を表示するための高さの担保のため、dummy で改行を表示する
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        //prepare textview to display muti-lines text
        let textView = UITextView()
        textView.text = (fetchObject as AnyObject).name
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 6
        //to dismiss keyboard
        textView.delegate = self
        textView.returnKeyType = UIReturnKeyType.done
        
        // textView を追加して Constraints を追加
        alert.view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(75)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-60)
        }
        
        // 画面が開いたあとでないと textView にフォーカスが当たらないため、遅らせて実行する
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            textView.becomeFirstResponder()
        }
        
        // Cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [] (_) in }))
        
        // 3. Grab the value from the text view, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [] (_) in
            if self.passedData! == "Cards" {
                (fetchObject as! Cards).name = textView.text
            } else {
                (fetchObject as! Punishments).name = textView.text
            }            
            do{
                try (fetchObject as AnyObject).managedObjectContext?.save()
            } catch {
                print("error")
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func add_alertView() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let message = "Add" + "\n\n\n\n\n\n\n"

        // textView を表示するための高さの担保のため、dummy で改行を表示する
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        
        //prepare textview to display muti-lines text
        let textView = UITextView()
        textView.text = ""
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 6
        textView.delegate = self
        textView.returnKeyType = UIReturnKeyType.done
        textView.font = UIFont(name: "Viga", size: 17)
        
        // textView を追加して Constraints を追加
        alert.view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(75)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-60)
        }
        
        // 画面が開いたあとでないと textView にフォーカスが当たらないため、遅らせて実行する
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            textView.becomeFirstResponder()
        }
        
        // Cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [] (_) in }))
        
        // 3. Grab the value from the text view, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [] (_) in
            if self.passedData! == "Cards" {
                // initializing Cards Entity
                let card_entity = NSEntityDescription.entity(forEntityName: "Cards", in: context)
                let newCard = NSManagedObject(entity: card_entity!, insertInto: context)
                newCard.setValue(textView.text, forKey: "name")
            } else {
                // initializing Punishments Entity
                let punishments_entity = NSEntityDescription.entity(forEntityName: "Punishments", in: context)
                let newCard = NSManagedObject(entity: punishments_entity!, insertInto: context)
                newCard.setValue(textView.text, forKey: "name")
            }
            try! context.save()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
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
