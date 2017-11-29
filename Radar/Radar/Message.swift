//
//  Message.swift
//  Radar
//
//  Created by student on 11/10/17.
//  Copyright © 2017 cs4720. All rights reserved.
//

import Foundation
import MapKit

class Message: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(content, forKey: "content")
        aCoder.encode(duration, forKey: "duration")
        aCoder.encode(distance, forKey: "distance")
        print("Setting Date..")
        aCoder.encode(date, forKey: "date")
        print("Setting Filter..")
        aCoder.encode(filter.rawValue, forKey: "filter")
        print("Setting Location..")
        //aCoder.encode(location, forKey: "location")
        aCoder.encode(location.latitude, forKey: "latitude")
        aCoder.encode(location.longitude, forKey: "longitude")
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let content = aDecoder.decodeObject(forKey: "content") as! String
        let duration = aDecoder.decodeDouble(forKey: "duration")
        let distance = aDecoder.decodeDouble(forKey: "distance")
        let date = aDecoder.decodeObject(forKey: "date") as! Date
        let filterString = aDecoder.decodeObject(forKey: "filter") as! String
        //let location = aDecoder.decodeObject(forKey: "location") as! CLLocationCoordinate2D
        let latitude = aDecoder.decodeDouble(forKey: "latitude")
        let longitude = aDecoder.decodeDouble(forKey: "longitude")
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        self.init(content: content, duration: duration, distance: distance, date: date, filter: Filter(rawValue: filterString)!, location: location)
    }
    
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
