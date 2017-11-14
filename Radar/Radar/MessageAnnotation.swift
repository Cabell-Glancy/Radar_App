//
//  MessageAnnotation.swift
//  Radar
//
//  Created by student on 11/10/17.
//  Copyright © 2017 cs4720. All rights reserved.
//

import Foundation
import MapKit

class MessageAnnotation: NSObject, MKAnnotation {
    var title: String?
    var message: Message
    var coordinate: CLLocationCoordinate2D { return message.location }
    
    init(message: Message) {
        self.message = message
        self.title = message.filter.rawValue
        super.init()
    }
}
