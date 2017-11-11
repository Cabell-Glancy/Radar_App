//
//  Message.swift
//  Radar
//
//  Created by student on 11/10/17.
//  Copyright © 2017 cs4720. All rights reserved.
//

import Foundation
import MapKit

class Message: NSObject {
    let content: String
    let duration: Int
    let distance: Int
    let filter: Filter
    let location: CLLocationCoordinate2D
    
    init(content: String, duration: Int, distance: Int, filter: Filter, location: CLLocationCoordinate2D) {
        self.content = content
        self.duration = duration
        self.distance = distance
        self.filter = filter
        self.location = location
        
        super.init()
    }
    
}
