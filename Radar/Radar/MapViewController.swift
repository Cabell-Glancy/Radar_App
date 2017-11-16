//
//  ViewController.swift
//  Radar
//
//  Created by student on 10/29/17.
//  Copyright © 2017 cs4720. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

private let kMessageAnnotationName = "kMessageAnnotationName"

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    //let locationManager = CLLocationManager()
    
    lazy var locationManager: CLLocationManager = {
        [unowned self] in
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //_locationManager.allowsBackgroundLocationUpdates = true
        _locationManager.pausesLocationUpdatesAutomatically = false  // So doesn't shut off if user stops to rest
        _locationManager.activityType = .fitness
        return _locationManager
        }()
    
    var userlocation = CLLocation(latitude: 38.03, longitude: -78.503611)
    //let delegate = UIApplication.shared.delegate as! AppDelegate
    
    let locationDelegate: LocationDelegate = LocationDelegate()
    
    var selectedMessage: Message?
    
    func handleMap() {
        print("HANDLEMAP+++++++++++++++++++++")
        let long = locationManager.location?.coordinate.longitude
        let lat = locationManager.location?.coordinate.latitude
        //let center = CLLocationCoordinate2D(latitude: userlocation.coordinate.latitude, longitude: userlocation.coordinate.longitude)
        let center = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        let viewRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))

        mapView.setRegion(viewRegion, animated: false)
        
        let message = Message(content: "Hello", duration: 50, distance: 50, filter: Filter.cute, location: CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)! + 0.01, longitude: (locationManager.location?.coordinate.longitude)! + 0.01))
        let message2 = Message(content: "Hello", duration: 50, distance: 50, filter: Filter.funny, location: CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)! + 0.01, longitude: (locationManager.location?.coordinate.longitude)! - 0.01))
        
        let messageAnnotation = MessageAnnotation(message: message)
        let messageAnnotation2 = MessageAnnotation(message: message2)
        
        mapView.addAnnotations([messageAnnotation, messageAnnotation2])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways     // Check authorization for location tracking
        {
            locationManager.requestWhenInUseAuthorization()
            //locationManager.requestAlwaysAuthorization()                    // LocationManager will callbackdidChange... once user responds
        } else {
            locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        print(String(describing: locationManager.location?.coordinate))

        mapView.center = view.center
    }
    
    func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status
        {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            self.handleMap()
            print("always authorize")
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            self.handleMap()
            print("authorized when in use")
        default:
            // User denied access, handle as appropriate
            print("u suck")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        


    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let reuseId = "marker"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MessageAnnotationView
        if annotationView == nil {
            annotationView = MessageAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            let messageanno = annotationView?.annotation as! MessageAnnotation
            if(messageanno.message.filter.rawValue == "CUTE") {
                annotationView?.markerTintColor = UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.5, alpha: 1.0)
            }
            else {
                annotationView?.markerTintColor = UIColor(displayP3Red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
            }
            annotationView?.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        //configureDetailView(annotationView: annotationView!)
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let calloutView = MessageDetail()
        calloutView.translatesAutoresizingMaskIntoConstraints = false
        calloutView.backgroundColor = UIColor.lightGray
        view.addSubview(calloutView)
        
        NSLayoutConstraint.activate([
            calloutView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            calloutView.widthAnchor.constraint(equalToConstant: 60),
            calloutView.heightAnchor.constraint(equalToConstant: 30),
            calloutView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.calloutOffset.x)
            ])
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: MKAnnotationView.self)
        {
            for subview in view.subviews
            {
                if subview.isKind(of: MessageDetail.self) {
                    subview.removeFromSuperview()
                }
            }
        }
    }
    
    func configureDetailView(annotationView: MessageAnnotationView) {
        let calloutView = MessageDetail()
        calloutView.translatesAutoresizingMaskIntoConstraints = false
        calloutView.backgroundColor = UIColor.lightGray
        annotationView.addSubview(calloutView)
        
        NSLayoutConstraint.activate([
            calloutView.bottomAnchor.constraint(equalTo: annotationView.topAnchor, constant: 0),
            calloutView.widthAnchor.constraint(equalToConstant: 60),
            calloutView.heightAnchor.constraint(equalToConstant: 30),
            calloutView.centerXAnchor.constraint(equalTo: annotationView.centerXAnchor, constant: annotationView.calloutOffset.x)
        ])
    }

}
