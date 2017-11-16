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
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
