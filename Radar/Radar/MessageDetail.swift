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
            messageContent.backgroundColor = UIColor.init(red: 227/255, green: 141/255, blue: 1, alpha: 1)
            backgroundArea.backgroundColor = UIColor.init(red: 227/255, green: 141/255, blue: 1, alpha: 1)
        }
        if filter.rawValue == "LOL!" {
            filterImage.image = UIImage(named: "lol-icon")
            messageContent.backgroundColor = UIColor.init(red: 140/255, green: 1, blue: 119/255, alpha: 1)
            backgroundArea.backgroundColor = UIColor.init(red: 140/255, green: 1, blue: 119/255, alpha: 1)
        }
        if filter.rawValue == "Aha!" {
            filterImage.image = UIImage(named: "education-icon")
            messageContent.backgroundColor = UIColor.init(red: 1, green: 242/255, blue: 136/255, alpha: 1)
            backgroundArea.backgroundColor = UIColor.init(red: 1, green: 242/255, blue: 136/255, alpha: 1)
        }
        if filter.rawValue == "Deal" {
            filterImage.image = UIImage(named: "deal-icon")
            messageContent.backgroundColor = UIColor.init(red: 159/255, green: 156/255, blue: 1, alpha: 1)
            backgroundArea.backgroundColor = UIColor.init(red: 159/255, green: 156/255, blue: 1, alpha: 1)
        }
        if filter.rawValue == "Secret" {
            filterImage.image = UIImage(named: "scavenger-icon")
            messageContent.backgroundColor = UIColor.init(red: 1, green: 225/255, blue: 182/255, alpha: 1)
            backgroundArea.backgroundColor = UIColor.init(red: 1, green: 225/255, blue: 182/255, alpha: 1)
            
        }
        if filter.rawValue == "Event" {
            filterImage.image = UIImage(named: "event-icon")
            messageContent.backgroundColor = UIColor.init(red: 1, green: 185/255, blue: 127/255, alpha: 1)
            backgroundArea.backgroundColor = UIColor.init(red: 1, green: 185/255, blue: 127/255, alpha: 1)
        }
        
    }
    
    @objc public func bookmarkMessage(_ sender: UIButton!) {
        // Store Message in CoreData
        let request = NSFetchRequest<NSManagedObject>(entityName: "StoreMessage")
        //request.predicate = NSPredicate(format: "message == %@", message!)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
            else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            let result = try managedContext.fetch(request)
            for resultmessage in result {
                let resultmessage = resultmessage.value(forKey: "message") as! Message
                if(resultmessage.content == message!.content) {
                    let alert = UIAlertController(title: "We get it, you like this.", message: "You cannot bookmark the same message twice.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.default, handler: nil))
                    UIApplication.shared.windows[0].rootViewController?.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
        catch {
            
        }
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
