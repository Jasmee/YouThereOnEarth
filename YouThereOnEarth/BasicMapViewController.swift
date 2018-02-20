//
//  BasicMapViewController.swift
//  YouThereOnEarth
//
//  Created by Jasmee Sengupta on 20/02/18.
//  Copyright © 2018 Jasmee Sengupta. All rights reserved.
//  Zoom to a location in map and drop a pin with tutle and subtitle

import UIKit
import  MapKit

class BasicMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let lattitude = 12.9602547
    let longitude = 77.58870290000004
    let deltaSpan = 0.005
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMapView()
        dropAPin()
    }

    func setUpMapView() {
        mapView.mapType = .standard
        let location = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: deltaSpan, longitudeDelta: deltaSpan)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func dropAPin() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
        annotation.title = "Landmark"
        annotation.subtitle = "Bangalore"
        mapView.addAnnotation(annotation)
    }

}

