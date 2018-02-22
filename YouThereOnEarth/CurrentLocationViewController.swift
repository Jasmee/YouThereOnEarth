//
//  CurrentLocationViewController.swift
//  YouThereOnEarth
//
//  Created by Jasmee Sengupta on 21/02/18.
//  Copyright © 2018 Jasmee Sengupta. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {
    

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
    }
    
    func setUpLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        //locationManager?.requestAlwaysAuthorization()
    }
    
    @IBAction func getCurrentLocation(_ sender: UIButton) {
        if CLLocationManager.locationServicesEnabled() {// returns true if system enabled
            if checkAuthorizationStatus() {
                locationManager?.startUpdatingLocation()
            } else {
                updateAuthorizationStatus()
            }
        } else {
            // Note: iOS already alerts the user when this VC is lodaded (only one time?)
            //Cannot present settings link, as it opens app settings, not system settings
            presentOkAlert(title: "Location services for device is disabled", message: "Go to Settings -> Privacy -> Location services to turn on")
        }
    }
    
    // MARK: Check for user authorization
    
    func checkAuthorizationStatus() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .notDetermined, .denied, .restricted:
            return false
        }
    }
    
    func updateAuthorizationStatus() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .denied, .restricted:
            presentSettingsAlert(title: "Location services is disabled for this app", message: "Please go to settings to enable location services")
        case .notDetermined:
            presentSettingsAlert(title: "Would you like to enable location services?", message: "Please go to settings")
        case .authorizedAlways, .authorizedWhenInUse:
            //can be written in default, making switch case exhaustive to show all cases
            print("Do nothing")
        }
    }
    
    // MARK: CLLocationManager delegate methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager?.startUpdatingLocation()// where to stop
        print("locations: \(locations)")
        let userCurrentLocation = locations.first // or last? chronological order?
        // Move map to region
        guard let center = userCurrentLocation?.coordinate else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        // Drop a pin
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "Current"
        annotation.subtitle = "Here you are"
        mapView.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        locationManager?.stopUpdatingLocation() // should stop here right? pr automatically stopped?
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //use case?
    }
    
    // MARK: Utilities
    
    // order of options, proper message
    func presentSettingsAlert(title: String, message: String) {// Open App Settings
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let SettingsAction = UIAlertAction(title: "Settings", style: .default) { action in
            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                } else {
                    print("permission restricted") // handle in app?
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(SettingsAction)
        present(alert, animated: true, completion: nil)
    }
    
    func presentOkAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
