//
//  CoreDataHelper.swift
//  playerSelection_collectionView
//
//  Created by Adrian on 3/15/18.
//  Copyright © 2018 Mei. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper: NSObject
{
    
    static let sharedInstance = CoreDataHelper()
    
    func appDelegate()->AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func managedObjectContext() -> NSManagedObjectContext
    {
        return self.appDelegate().persistentContainer.viewContext
    }
    
    /*
     Purpose: TO fetch the coredata saved in AppDelegate
     entityName: name of the entity
     sortDescriptorKey: any one of the attribute within the entity
     */
    func fetch(context: NSManagedObjectContext, entityName: String, sortDescriptorKey: String, selected: Int, isPredicate: Bool) -> Any
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        //load coreData
        do {
            //optional to use predicate
            if isPredicate {
                //fetch result based on the "selected" attribute
                fetchRequest.predicate = NSPredicate(format: "selected == %d", selected)
            }            
            // Add Sort Descriptor
            let sortDescriptor = NSSortDescriptor(key: sortDescriptorKey, ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            return try! context.fetch(fetchRequest)
        }
    }
    
    /* save an entity including its attributes*/
    func set(entityName: NSEntityDescription, context: NSManagedObjectContext, name: String, row: Int, selected: Int, selected_row: Int)
    {
        let character = NSManagedObject(entity: entityName, insertInto: context)
        character.setValue(name, forKey: "name")
        character.setValue(row, forKey: "row")
        character.setValue(selected, forKey: "selected")
        character.setValue(selected_row, forKey: "selected_row")
    }
}


