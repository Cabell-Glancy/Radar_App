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

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager?
    var selectedMessage: Message?
    
    func createLocationManager(startImmediately: Bool){
        // Add code to start the locationManager
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager!.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager!.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
        
    }
    
    func startGPS() {
        if CLLocationManager.locationServicesEnabled(){
            
            switch CLLocationManager.authorizationStatus(){
            case .authorizedAlways:
                /* Yes, always */
                createLocationManager(startImmediately: true)
            case .authorizedWhenInUse:
                /* Yes, only when our app is in use  */
                createLocationManager(startImmediately: true)
            case .denied:
                /* No */
                displayAlertWithTitle(title: "Not Determined",
                                      message: "Location services are not allowed for this app")
            case .notDetermined:
                /* We don't know yet, we have to ask */
                createLocationManager(startImmediately: false)
                if let manager = self.locationManager{
                    manager.requestWhenInUseAuthorization()
                }
            case .restricted:
                /* Restrictions have been applied, we have no access
                 to location services */
                displayAlertWithTitle(title: "Restricted",
                                      message: "Location services are not allowed for this app")
            }
            
            
        } else {
            /* Location services are not enabled.
             Take appropriate action: for instance, prompt the
             user to enable the location services */
            let alertController = UIAlertController(title: NSLocalizedString("Location Services are currently disabled.", comment: ""), message: NSLocalizedString("Activate them under Privacy Settings to use the GPS service.", comment: ""), preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
            let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
                UIApplication.shared.openURL(NSURL(string: "App-Prefs:root=LOCATION_SERVICES")! as URL)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            self.present(alertController, animated: true, completion: nil)
            print("Location services are not enabled")
        }
        
    }
    
    func displayAlertWithTitle(title: String, message: String){
        // Helper function for displaying dialog windows - no edits needed.
        let controller = UIAlertController(title: title,
                                           message: message,
                                           preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "OK",
                                           style: .default,
                                           handler: nil))
        
        present(controller, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let locationManager = CLLocationManager()
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        //Zoom to user location
            let center = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
                viewRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
                

        mapView.setRegion(viewRegion, animated: false)
        
//        DispatchQueue.main.async {
//            locationManager.startUpdatingLocation()
//        }
        
        mapView.center = view.center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
//        let message = Message(content: "Hello", duration: 50, distance: 50, filter: Filter.cute, location: CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)! + 0.01, longitude: (locationManager.location?.coordinate.longitude)! + 0.01))
//        let message2 = Message(content: "Hello", duration: 50, distance: 50, filter: Filter.funny, location: CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)! + 0.01, longitude: (locationManager.location?.coordinate.longitude)! - 0.01))
//
//        let messageAnnotation = MessageAnnotation(message: message)
//        let messageAnnotation2 = MessageAnnotation(message: message2)
//
//        mapView.addAnnotations([messageAnnotation, messageAnnotation2])

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

