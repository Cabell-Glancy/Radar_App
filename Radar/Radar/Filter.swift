//
//  Filter.swift
//  Radar
//
//  Created by student on 11/10/17.
//  Copyright © 2017 cs4720. All rights reserved.
//

import Foundation

enum Filter: String {
    case event = "Event"
    case deal = "Deal"
    case funny = "LOL!"
    case cute = "CUTE"
    case educational = "Aha!"
    case scavenger_hunt = "Secret"
    
    static let allValues = [event.rawValue, deal.rawValue, funny.rawValue, cute.rawValue, educational.rawValue, scavenger_hunt.rawValue]
    
    static let imageValues = ["event-icon", "deal-icon", "lol-icon", "dog-icon", "education-icon", "scavenger-icon"]
}
