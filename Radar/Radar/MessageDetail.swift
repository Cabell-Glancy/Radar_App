//
//  MessageDetail.swift
//  Radar
//
//  Created by student on 11/14/17.
//  Copyright © 2017 cs4720. All rights reserved.
//

import UIKit

class MessageDetail: UIView {

    @IBOutlet weak var filterTitle: UILabel!
    @IBOutlet weak var filterImage: UIImageView!
    @IBOutlet weak var messageDate: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var messageContent: UILabel!
    @IBOutlet weak var backgroundArea: UIButton!
    
    //var message: Message
    
    public func populateWithMessage(message: Message) {
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
