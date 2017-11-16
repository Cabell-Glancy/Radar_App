//
//  LocationDelegate.swift
//  Radar
//
//  Created by student on 11/15/17.
//  Copyright © 2017 cs4720. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class LocationDelegate: NSObject, CLLocationManagerDelegate {
    
    var currentLocation: CLLocation?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentLocation == nil {
            currentLocation = locations.last
            manager.stopMonitoringSignificantLocationChanges()
            let locationValue:CLLocationCoordinate2D = manager.location!.coordinate
            
            print("locations = \(locationValue)")
            
            manager.stopUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
                switch CLLocationManager.authorizationStatus(){
                case .authorizedAlways:
                    manager.startUpdatingLocation()
                    print("Authorized")
                case .authorizedWhenInUse:
                    manager.startUpdatingLocation()
                    print("Authorized when in use")
                case .denied:
                    print("Denied")
                case .notDetermined:
                    manager.requestAlwaysAuthorization()
                    print("Not determined")
                case .restricted:
                    print("Restricted")
                }
    }
    
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }}
