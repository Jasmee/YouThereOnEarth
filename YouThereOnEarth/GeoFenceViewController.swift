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
            setUpGeoFenceFor(location: "office")
        }
    }
    
    func setUpLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
    }
    
    func setUpGeoFenceFor(location: String) {
        var coordinate: CLLocationCoordinate2D?
        if let placeName = place(rawValue: location) {
            coordinate = getCoordinates(location: placeName)
        }
        guard let center = coordinate else {
            print("Could not get location coordiantes")
            return
        }
        let geoFenceRegion = CLCircularRegion(center: center, radius: 400, identifier: "Manyata D3")
        geoFenceRegion.notifyOnEntry = true
        geoFenceRegion.notifyOnExit = true
        locationManager?.startMonitoring(for: geoFenceRegion)
    }
    
    func getCoordinates(location: place) -> CLLocationCoordinate2D {
        switch location {
        case place.home:
            return HOME_COORDINATE
        case place.office:
            return OFFICE_COORDINATE
        case place.spar:
            return SPAR_COORDINATE
        case place.kalyannagar:
            return KALYANNAGAR_COORDINATE
        }
    }
    
    // MARK: CLLocationManager Delegates
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            setUpGeoFenceFor(location: "office")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("entered")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit")
    }
    
}
