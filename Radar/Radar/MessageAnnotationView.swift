//
//  MessageAnnotationView.swift
//  Radar
//
//  Created by student on 11/10/17.
//  Copyright © 2017 cs4720. All rights reserved.
//
//
//import Foundation
//import MapKit
//
//private let kMessageMapAnimationTime = 0.300
//private let kMessageMapPinImage = UIImage(named: "mapPin")!
//
//class MessageAnnotationView: MKAnnotationView {
//    weak var messageDetailDelegate: MessageDetailMapViewDelegate?
//    weak var customCalloutView: MessageDetailMapView?
//    override var annotation: MKAnnotation? {
//        willSet { customCalloutView?.removeFromSuperview() }
//    }
//
//    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
//        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//        self.image = kMessageMapPinImage
//        self.canShowCallout = false
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.image = kMessageMapPinImage
//        self.canShowCallout = false
//    }
//
//    func loadMessageDetailMapView() -> MessageDetailMapView? {
//        if let views = Bundle.main.loadNibNamed("MessageDetailMapView", owner: self, options: nil) as? [MessageDetailMapView], views.count > 0 {
//            let messageDetailMapView = views.first!
//            messageDetailMapView.delegate = self.messageDetailDelegate
//            if let messageAnnotation = annotation as? MessageAnnotation {
//                let message = messageAnnotation.message
//                messageDetailMapView.configureWithMessage(message: message)
//            }
//            return messageDetailMapView
//        }
//        return nil
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        if selected {
//            self.customCalloutView?.removeFromSuperview()
//
//            if let newCustomCalloutView = loadMessageDetailMapView() {
//                newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
//                newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
//
//                self.addSubview(newCustomCalloutView)
//                self.customCalloutView = newCustomCalloutView
//
//                if animated {
//                    UIView.animate(withDuration: kMessageMapAnimationTime, animations: { self.customCalloutView!.alpha = 0.0}, completion: { (success) in self.customCalloutView!.removeFromSuperview()
//                })
//                }
//            } else {
//                self.customCalloutView!.removeFromSuperview()
//            }
//        }
//    }

//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.customCalloutView?.removeFromSuperview()
//    }
//}

