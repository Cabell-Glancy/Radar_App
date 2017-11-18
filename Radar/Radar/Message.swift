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
    let duration: Double
    let distance: Double
    let date: Date
    let filter: Filter
    let location: CLLocationCoordinate2D
    
    init(content: String, duration: Double, distance: Double, date: Date, filter: Filter, location: CLLocationCoordinate2D) {
        self.content = content
        self.duration = duration
        self.distance = distance
        self.date = date
        self.filter = filter
        self.location = location
        
        super.init()
    }
    
}
