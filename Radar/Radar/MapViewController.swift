//
//  ViewController.swift
//  Radar
//
//  Created by student on 10/29/17.
//  Copyright © 2017 cs4720. All rights reserved.
//

import UIKit
import MapKit

private let kMessageAnnotationName = "kMessageAnnotationName"

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    var locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedMessage: Message?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        //Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        //Zoom to user location
        let center = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        let viewRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        mapView.setRegion(viewRegion, animated: false)
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
        mapView.center = view.center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let message = Message(content: "Hello", duration: 50, distance: 50, filter: Filter.cute, location: CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)! + 0.01, longitude: (locationManager.location?.coordinate.longitude)! + 0.01))
        let message2 = Message(content: "Hello", duration: 50, distance: 50, filter: Filter.funny, location: CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)! + 0.01, longitude: (locationManager.location?.coordinate.longitude)! - 0.01))
        
        let messageAnnotation = MessageAnnotation(message: message)
        let messageAnnotation2 = MessageAnnotation(message: message2)
        
        mapView.addAnnotations([messageAnnotation, messageAnnotation2])
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let reuseId = "marker"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MessageAnnotationView
        if annotationView == nil {
            annotationView = MessageAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView?.canShowCallout = true
            let messageanno = annotationView?.annotation as! MessageAnnotation
            if(messageanno.message.filter.rawValue == "CUTE") {
                annotationView?.markerTintColor = UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.5, alpha: 1.0)
            }
            else {
                annotationView?.markerTintColor = UIColor(displayP3Red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
            }
        }
        else {
            annotationView!.annotation = annotation
        }
        
        configureDetailView(annotationView: annotationView!)
        
        return annotationView
    }
    
    func configureDetailView(annotationView: MessageAnnotationView) {

    }

}

//let message = Message(content: "Hello", duration: 50, distance: 50, filter: Filter.cute, location: CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.a, longitude: locationManager.location?.coordinate.longitude))

//let messageAnnotation = MessageAnnotation(message: message)

//mapView.addAnnotation(messageAnnotation)


//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let userLocation:CLLocation = locations[0] as CLLocation
//
//        // Call stopUpdatingLocation() to stop listening for location updates,
//        // other wise this function will be called every time when user location changes.
//        //manager.stopUpdatingLocation()
//
//        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//
//        mapView.setRegion(region, animated: true)
//        manager.stopUpdatingLocation()
//
//    }

//    func determineCurrentLocation()
//    {
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
//
//        if CLLocationManager.locationServicesEnabled() {
//            //locationManager.startUpdatingHeading()
//            locationManager.startUpdatingLocation()
//        }
//       print(String(describing: locationManager.location?.coordinate))
//    }

//        else {
//            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MessageAnnotationView()
//            //annotationView.image = UIImage(named: "mapPin")
//            //let annotation = annotationView as! MKMarkerAnnotationView
//            let annotation = annotationView as! MessageAnnotationView
//            //annotation.markerTintColor = UIColor(displayP3Red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
//            return annotation
//        }

