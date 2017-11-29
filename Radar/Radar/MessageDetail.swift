//
//  MessageDetail.swift
//  Radar
//
//  Created by student on 11/14/17.
//  Copyright © 2017 cs4720. All rights reserved.
//

import UIKit
import CoreData

class MessageDetail: UIView {

    @IBOutlet weak var filterTitle: UILabel!
    @IBOutlet weak var filterImage: UIImageView!
    @IBOutlet weak var messageDate: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var messageContent: UILabel!
    @IBOutlet weak var backgroundArea: UIButton!
    weak var message: Message?
    
    //var message: Message
    
    public func populateWithMessage(message: Message) {
        self.message = message
        filterTitle.text = message.filter.rawValue
        messageContent.text = message.content
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.unitsStyle = .abbreviated
        messageDate.text = formatter.string(from: message.date, to: Date())! + " ago"
        setImage(filter: message.filter)
    }
    
    public func setImage(filter: Filter) {
        if filter.rawValue == "CUTE" {
            filterImage.image = UIImage(named: "dog-icon")
        }
        if filter.rawValue == "LOL!" {
            filterImage.image = UIImage(named: "lol-icon")
        }
        if filter.rawValue == "Aha!" {
            filterImage.image = UIImage(named: "education-icon")
        }
        if filter.rawValue == "Deal" {
            filterImage.image = UIImage(named: "deal-icon")
        }
        if filter.rawValue == "Secret" {
            filterImage.image = UIImage(named: "scavenger-icon")
        }
        if filter.rawValue == "Event" {
            filterImage.image = UIImage(named: "event-icon")
        }
        
    }
    
    @objc public func bookmarkMessage(_ sender: UIButton!) {
        // Store Message in CoreData
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let messageTest = NSEntityDescription.insertNewObject(forEntityName: "StoreMessage", into: context)
        messageTest.setValue(message, forKey: "message")
        messageTest.setValue(false, forKey: "sender")
        
        do {
            try context.save()
        }
        catch {
            print("Nup")
        }    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
