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
import FirebaseDatabase
import CoreData

private let kMessageAnnotationName = "kMessageAnnotationName"

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var quickdropField: UITextField!
    //let locationManager = CLLocationManager()
    
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        self.refresh()
    }
    
    var postData = [String]()
    
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
    
    var selectedMessage: Message?
    
    func handleMap() {
        print("HANDLEMAP+++++++++++++++++++++")
        let long = locationManager.location?.coordinate.longitude
        let lat = locationManager.location?.coordinate.latitude
        //let center = CLLocationCoordinate2D(latitude: userlocation.coordinate.latitude, longitude: userlocation.coordinate.longitude)
        let center = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        let viewRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))

        mapView.setRegion(viewRegion, animated: false)
        
        fire_pull()
        
        let message = Message(content: "A dachshund looking like a tiny hotdog, this is #2cute, come here ASAP peepz", duration: 50, distance: 50, date: Date(timeIntervalSinceReferenceDate: 532623600), filter: Filter.cute, location: CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)! + 0.01, longitude: (locationManager.location?.coordinate.longitude)! + 0.01))
        let message2 = Message(content: "Someone just fell over and he is still trying to get up. Too funny OMG", duration: 50, distance: 50, date: Date(timeIntervalSinceReferenceDate: 532623200), filter: Filter.funny, location: CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)! + 0.01, longitude: (locationManager.location?.coordinate.longitude)! - 0.01))
        
        let messageAnnotation = MessageAnnotation(message: message)
        let messageAnnotation2 = MessageAnnotation(message: message2)
        
        mapView.addAnnotations([messageAnnotation, messageAnnotation2])
    }
    
    func fire_pull(){
        var ref: DatabaseReference!
        var databaseHandle: DatabaseHandle?
        ref = Database.database().reference().child("Messages")
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
//            print(snapshot.value!)
            
            let array:NSArray = snapshot.children.allObjects as NSArray
            
            for obj in array{
                let snapshot:DataSnapshot = obj as! DataSnapshot
                print(obj)
                if let data = snapshot.value as? [String:Any]{
                    let con = data["Content"] as! String
//                    print(data["Date"])
                    let dat = data["Date"] as! String
//                    print(dat)
                    let dis = data["Distance"] as? Double
                    let dur = data["Duration"] as? Double
                    let fil = data["Filter"] as! String
                    let lat = data["Latitiude"] as? Double
                    let long = data["Longitude"] as? Double
                    
                    let dateFormatter = DateFormatter()
                    print("dat: " + dat)
                    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss ZZZ"
                    dateFormatter.timeZone = TimeZone(identifier: "GMT")
                    let converted_date = dateFormatter.date(from: dat)
                    
                    let message = Message(content: con , duration: dur!, distance: dis!, date: converted_date!, filter: Filter(rawValue: fil)!, location: CLLocationCoordinate2D(latitude: lat!, longitude: long!))
                    
                    let messageAnnotation = MessageAnnotation(message: message)
                    
                    // DISTANCE FILTER TEST
                    let distance = MKMetersBetweenMapPoints(MKMapPointForCoordinate((self.locationManager.location?.coordinate)!), MKMapPointForCoordinate(messageAnnotation.coordinate))/1609.344 // get distance in miles
                    print("COMPARISON: " + String(distance) + "vs. " + String(UserDefaults.standard.double(forKey: "personalRange")))
                    print(distance > UserDefaults.standard.double(forKey: "personalRange"))
                    print(distance > messageAnnotation.message.distance)
                    var withinRange = false
                    var withinTime = false
                    if(!(distance > UserDefaults.standard.double(forKey: "personalRange")) && !(distance > messageAnnotation.message.distance)) {
                        withinRange = true
                        //self.mapView.addAnnotation(messageAnnotation)
                    }
                    // DURATION FILTER
                    let duration = Date().timeIntervalSince(converted_date!)
                    print("current time: " + String(describing: Date()))
                    print("message time: " + String(describing: converted_date!))
                    //let duration = DateInterval(start: converted_date!, end: Date())
                    print(String(duration))
                    print(String(duration/3600))
                    
                    print("MESSAGEDURATION: " + String(describing: messageAnnotation.message.duration))
                    if(!(duration/3600 > messageAnnotation.message.duration)) {
                        withinTime = true
                    }
                    
                    if(withinTime && withinRange) {
                        self.mapView.addAnnotation(messageAnnotation)
                    }
                    print("Distance: " + String(distance))
                    

                    
                    //self.mapView.addAnnotation(messageAnnotation)
                }
            }
        
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Radar"
        
        self.quickdropField.delegate = self
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways     // Check authorization for location tracking
        {
            print("I am running")
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization() // LocationManager will callbackdidChange... once user responds
            print("WOT")
        } else {
            print("I am also running")
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
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            self.handleMap()
        default:
            // User denied access, handle as appropriate
            print("default")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func filterByDistance() { // this has to be called in handlemap and viewdidappear once firebase is implemented
        let annotations = mapView.annotations // Has to be pulled from firebase
        mapView.removeAnnotations(annotations)
        
        for annotation in annotations {
            if(annotation is MKUserLocation) {
                continue
            }
            let mapAnnotation = annotation as! MessageAnnotation
            let distance = MKMetersBetweenMapPoints(MKMapPointForCoordinate((locationManager.location?.coordinate)!), MKMapPointForCoordinate(annotation.coordinate))/1609.344 // get distance in miles
            if(!(distance > UserDefaults.standard.double(forKey: "personalRange") || distance > mapAnnotation.message.distance)) {
                mapView.addAnnotation(mapAnnotation)
            }
            print("Distance: " + String(distance))
        }
    }
    
    func refresh() {
        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)
        self.fire_pull()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(!UserDefaults.standard.bool(forKey: "isQdEnabled")) {
            self.quickdropField.isHidden = true
        }
        else {
            self.quickdropField.isHidden = false
        }
        self.refresh()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        var reuseId = "marker"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MessageAnnotationView
        if annotationView == nil {
            annotationView = MessageAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            let messageanno = annotationView?.annotation as! MessageAnnotation
            
            switch (messageanno.message.filter.rawValue) {
            case "CUTE":
                reuseId = "CUTE"
                annotationView?.markerTintColor = UIColor.purple
                annotationView?.glyphImage = UIImage(named: "dog-icon")
            case "LOL!":
                reuseId = "LOL!"
                annotationView?.markerTintColor = UIColor.green
                annotationView?.glyphImage = UIImage(named: "lol-icon")
            case "Aha!":
                reuseId = "Aha!"
                annotationView?.markerTintColor = UIColor.yellow
                annotationView?.glyphImage = UIImage(named: "education-icon")
            case "Secret":
                reuseId = "Secret"
                annotationView?.markerTintColor = UIColor.brown
                annotationView?.glyphImage = UIImage(named: "scavenger-icon")
            case "Deal":
                reuseId = "Deal"
                annotationView?.markerTintColor = UIColor.blue
                annotationView?.glyphImage = UIImage(named: "deal-icon")
            case "Event":
                reuseId = "Event"
                annotationView?.markerTintColor = UIColor.orange
                annotationView?.glyphImage = UIImage(named: "event-icon")
            default:
                annotationView?.markerTintColor = UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            }
            annotationView?.canShowCallout = true
        }
        else {
            annotationView = MessageAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            let messageanno = annotationView!.annotation as! MessageAnnotation
            
            switch (messageanno.message.filter.rawValue) {
            case "CUTE":
                reuseId = "CUTE"
                annotationView?.markerTintColor = UIColor.purple
                annotationView?.glyphImage = UIImage(named: "dog-icon")
            case "LOL!":
                reuseId = "LOL!"
                annotationView?.markerTintColor = UIColor.green
                annotationView?.glyphImage = UIImage(named: "lol-icon")
            case "Aha!":
                reuseId = "Aha!"
                annotationView?.markerTintColor = UIColor.yellow
                annotationView?.glyphImage = UIImage(named: "education-icon")
            case "Secret":
                reuseId = "Secret"
                annotationView?.markerTintColor = UIColor.brown
                annotationView?.glyphImage = UIImage(named: "scavenger-icon")
            case "Deal":
                reuseId = "Deal"
                annotationView?.markerTintColor = UIColor.blue
                annotationView?.glyphImage = UIImage(named: "deal-icon")
            case "Event":
                reuseId = "Event"
                annotationView?.markerTintColor = UIColor.orange
                annotationView?.glyphImage = UIImage(named: "event-icon")
            default:
                annotationView?.markerTintColor = UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            }
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
            return
        }
        let calloutView = (Bundle.main.loadNibNamed("MessageDetail", owner: self, options: nil))?[0] as! MessageDetail
        let calloutViewFrame = calloutView.frame
        calloutView.frame = CGRect(x: -calloutViewFrame.size.width/2.23, y: -calloutViewFrame.size.height+10, width: 228, height: 213)
        //calloutView.populateWithMessage(message: Message)
        if let messageannotation = view.annotation as? MessageAnnotation {
            calloutView.populateWithMessage(message: messageannotation.message)
        }
        let bookmarkButton = calloutView.bookmarkButton
        bookmarkButton?.addTarget(calloutView, action: #selector(calloutView.bookmarkMessage), for: .touchUpInside)
        
        view.addSubview(calloutView)
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
    
    func fire_post(postcontent:String!, duration: Double!, distance: Double!, date: String!, filter: String!, latitude: Double!, longitude: Double!){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let parentRef = ref?.child("Messages").childByAutoId()
        
        parentRef?.child("Content").setValue(postcontent)
        parentRef?.child("Duration").setValue(duration)
        parentRef?.child("Distance").setValue(distance)
        parentRef?.child("Date").setValue(date)
        parentRef?.child("Filter").setValue(filter)
        parentRef?.child("Latitiude").setValue(latitude)
        parentRef?.child("Longitude").setValue(longitude)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        quickdropField.resignFirstResponder()
        if(quickdropField.text == "") {
            return false
        }
        
        let date_new = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        let converted_date = dateFormatter.string(from: date_new )
        let final_date = converted_date + " +0000"
        
//        print("--------------")
//        print(final_date)
//        print("--------------")
        
        fire_post(postcontent: quickdropField.text! ,duration: UserDefaults.standard.double(forKey: "qdDuration"), distance:UserDefaults.standard.double(forKey: "qdDistance"), date: final_date, filter: Filter.cute.rawValue, latitude: (locationManager.location?.coordinate)!.latitude, longitude:(locationManager.location?.coordinate)!.longitude)
        
       let message = Message(content: quickdropField.text!, duration: UserDefaults.standard.double(forKey: "qdDuration"), distance: UserDefaults.standard.double(forKey: "qdDistance"), date: Date(), filter: Filter.cute, location: (locationManager.location?.coordinate)!)
       let messageAnnotation = MessageAnnotation(message: message)
       mapView.addAnnotation(messageAnnotation)
        quickdropField.text = ""
        
        // Store Message in CoreData
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let messageTest = NSEntityDescription.insertNewObject(forEntityName: "StoreMessage", into: context)
        messageTest.setValue(message, forKey: "message")
        messageTest.setValue(true, forKey: "sender")
        
        do {
            try context.save()
        }
        catch {
            print("Nup")
        }
        
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField: quickdropField, moveDistance: -250, up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField: quickdropField, moveDistance: -250, up: false)
    }
    
    func moveTextField(textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }

}
