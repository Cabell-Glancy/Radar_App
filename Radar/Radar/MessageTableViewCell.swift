//
//  MessageTableViewCell.swift
//  Radar
//
//  Created by student on 11/28/17.
//  Copyright © 2017 cs4720. All rights reserved.
//

import UIKit
import MapKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var findButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
