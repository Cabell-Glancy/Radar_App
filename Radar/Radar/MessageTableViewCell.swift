//
//  MessageTableViewCell.swift
//  Radar
//
//  Created by student on 11/28/17.
//  Copyright © 2017 cs4720. All rights reserved.
//

import UIKit
import MapKit

class MessageTableViewCell: UITableViewCell, MKMapViewDelegate {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    weak var cellMessage : Message?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let mapView = self.mapView {
            mapView.delegate = self
            mapView.showsPointsOfInterest = true
            mapView.isUserInteractionEnabled = false
        }
        // Initialization code
    }
    
    func showLocation(message: Message) {
        cellMessage = message
        let long = message.location.longitude
        let lat = message.location.latitude
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let viewRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        let annotation = MessageAnnotation(message: message)
        mapView.addAnnotation(annotation)
        
        mapView.setRegion(viewRegion, animated: false)
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
            
            switch (messageanno.message.filter.rawValue) {
            case "CUTE":
                annotationView?.markerTintColor = UIColor.purple
                annotationView?.glyphImage = UIImage(named: "dog-icon")
            case "LOL!":
                annotationView?.markerTintColor = UIColor.green
                annotationView?.glyphImage = UIImage(named: "lol-icon")
            case "Aha!":
                annotationView?.markerTintColor = UIColor.yellow
                annotationView?.glyphImage = UIImage(named: "education-icon")
            case "Secret":
                annotationView?.markerTintColor = UIColor.brown
                annotationView?.glyphImage = UIImage(named: "scavenger-icon")
            case "Deal":
                annotationView?.markerTintColor = UIColor.blue
                annotationView?.glyphImage = UIImage(named: "deal-icon")
            case "Event":
                annotationView?.markerTintColor = UIColor.orange
                annotationView?.glyphImage = UIImage(named: "event-icon")
            default:
                annotationView?.markerTintColor = UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            }
            annotationView?.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
