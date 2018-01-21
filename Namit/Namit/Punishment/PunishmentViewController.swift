//
//  PunishmentViewController.swift
//  NameIt
//
//  Created by KaKin Chiu on 12/28/17.
//  Copyright © 2017 zhipeng. All rights reserved.
//

import UIKit
import CoreData

class PunishmentViewController: UIViewController,SpinWheelControlDataSource, SpinWheelControlDelegate, NSFetchedResultsControllerDelegate{
    
    @IBOutlet var punishment_view: UIView!
    @IBOutlet weak var spinWheelView: UIView!
    @IBOutlet weak var cancel_button: FlatButton!
    @IBOutlet weak var down_arrow_image: UIImageView!
    @IBOutlet weak var punishment_label: UILabel!
    @IBOutlet weak var label_view: UIView!
    @IBOutlet weak var again_button: UIButton!
    
    let c1 = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1.0)
    let c2 = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1.0)
    let c3 = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1.0)
    let c4 = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
    let c5 = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1.0)
    let c6 = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
    let c7 = UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1.0)
    let c8 = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1.0)
    
    let c9 = UIColor(red: 248/255, green: 194/255, blue: 215/255, alpha: 1.0)
    let c10 = UIColor(red: 120/255, green: 172/255, blue: 232/255, alpha: 1.0)
    let c11 = UIColor(red: 206/255, green: 214/255, blue: 226/255, alpha: 1.0)
    let c12 = UIColor(red: 212/255, green: 133/255, blue: 245/255, alpha: 1.0)
    let c13 = UIColor(red: 136/255, green: 225/255, blue: 122/255, alpha: 1.0)
    let c14 = UIColor(red: 243/255, green: 87/255, blue: 109/255, alpha: 1.0)
    
    var colorPalette: [UIColor] = []

    // MARK: -
    //default for NSFetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Punishments")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()

    func numberOfWedgesInSpinWheel(spinWheel: SpinWheelControl) -> UInt {
        return 14
    }
    
    func wedgeForSliceAtIndex(index: UInt) -> SpinWheelWedge {
        let wedge = SpinWheelWedge()

        wedge.shape.fillColor = colorPalette[Int(index)].cgColor
        wedge.label.text = " " + String(index)
        
        return wedge
    }
    
    var spinWheelControl:SpinWheelControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Save Note")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        colorPalette = [c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14]
        
        // A UIImageView with async loading
        down_arrow_image.loadGif(name: "arrow")
        
        //modify cancel button
        let color = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1.0)
        cancel_button.setTitleColor(UIColor.white, for: .normal)
        cancel_button.color = color
        cancel_button.highlightedColor = color
        cancel_button.selectedColor = .blue
        cancel_button.cornerRadius = 8
        
        //change UIview background
        let bg_color = UIColor(red: 19/255, green: 38/255, blue: 51/255, alpha: 1.0)
        self.punishment_view.backgroundColor = bg_color
        self.spinWheelView.backgroundColor = bg_color
        
        let view_color = UIColor(red: 196/255, green: 55/255, blue: 48/255, alpha: 0.95)
        self.label_view.layer.cornerRadius = 8
        self.label_view.backgroundColor = view_color
        self.label_view.alpha = 0
        
        self.punishment_label.textColor = UIColor.white
        let button_color = UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1.0)
        self.again_button.backgroundColor = button_color
        self.again_button.setTitleColor(UIColor.white, for: .normal)
        self.again_button.layer.cornerRadius = 8
        self.again_button.setTitle(GoogleIcon.icons()[1518], for: .normal)

        //instantiate the UI control with a frame
        let frame = CGRect(x:0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)

        spinWheelControl = SpinWheelControl(frame: frame)
        
        //Add a target for the valueChanged event
        spinWheelControl.addTarget(self, action: #selector(spinWheelDidChangeValue), for: UIControlEvents.valueChanged)
        
        spinWheelControl.dataSource = self
        spinWheelControl.reloadData()
        spinWheelControl.delegate = self
        spinWheelView.addSubview(spinWheelControl)
    }
    
    //Target was added in viewDidLoad for the valueChanged UIControlEvent
    @objc func spinWheelDidChangeValue(sender: AnyObject) {
        print("Value changed to " + String(self.spinWheelControl.selectedIndex))
        
        let curIndexPath = IndexPath(row: self.spinWheelControl.selectedIndex, section: 0)
        let card = self.fetchedResultsController.object(at: curIndexPath) as! Punishments
        self.punishment_label.text = card.name!

        self.label_view.alpha = 1
    }
    
    func spinWheelDidEndDecelerating(spinWheel: SpinWheelControl) {
        print("The spin wheel did end decelerating.")
    }
    
    @IBAction func again_action(_ sender: Any) {
        self.label_view.alpha = 0
    }
    
}
