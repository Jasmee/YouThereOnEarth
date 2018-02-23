//
//  GeoFenceViewController.swift
//  YouThereOnEarth
//
//  Created by Jasmee Sengupta on 23/02/18.
//  Copyright © 2018 Jasmee Sengupta. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

enum place: String {// can omit raw value if name matches
    case home = "home"
    case office = "office"
    case spar = "spar"
    case kalyannagar = "kalyannagar"
}

class GeoFenceViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
            setUpGeoFenceFor(location: "Office")
        }
    }
    
    func setUpLocationManager() {
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
    }
    
    func setUpGeoFenceFor(location: String) {
        var coordinate = CLLocationCoordinate2D()
        if let placeName = place(rawValue: location) {
            getCoordinates(location: placeName)
        }
    
        let center = CLLocationCoordinate2D(latitude: 13, longitude: 77)
        let geoFenceRegion = CLCircularRegion(center: center, radius: 400, identifier: "Manyata D3")
        geoFenceRegion.notifyOnEntry = true
        geoFenceRegion.notifyOnExit = true
        locationManager?.startMonitoring(for: geoFenceRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            setUpGeoFenceFor(location: "Office")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("entered")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit")
    }
    
    func getCoordinates(location: place) -> CLLocationCoordinate2D {
        switch location {
        case place.home:
            return CLLocationCoordinate2D(latitude: 13, longitude: 77)
        case place.office:
            return CLLocationCoordinate2D(latitude: 13, longitude: 77)
        case place.spar:
            return CLLocationCoordinate2D(latitude: 13, longitude: 77)
        case place.kalyannagar:
            return CLLocationCoordinate2D(latitude: 13, longitude: 77)
        }
    }
    
}
