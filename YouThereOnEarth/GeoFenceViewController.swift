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
import UserNotifications

enum place: String {// can omit raw value if name matches
    case home = "Home"
    case manyata_d3 = "Manyata D3"
    case manyata_escape = "Manyata Escape"
    case spar = "SPAR"
    case kalyannagar = "Kalyannagar"
}

class GeoFenceViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
        requestNotificationPermission()
        if CLLocationManager.locationServicesEnabled() {
            setUpGeoFenceFor(location: "Manyata Escape")
        }
        // Uncomment this to check if local notification is working on device
        //dummyNotification(title: "Entering", subtitle: "Monitored region", body: "You are entering the monitored region")
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
        let geoFenceRegion = CLCircularRegion(center: center, radius: 100, identifier: "Manyata Escape")
        geoFenceRegion.notifyOnEntry = true
        geoFenceRegion.notifyOnExit = true
        locationManager?.startMonitoring(for: geoFenceRegion)
        zoomAndPinToGeoFence(center: center, location: location)
    }
    
    func zoomAndPinToGeoFence(center: CLLocationCoordinate2D, location:  String) {
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = location
        annotation.subtitle = "\(center.latitude), \(center.longitude)"
        mapView.addAnnotation(annotation)
    }
    
    func getCoordinates(location: place) -> CLLocationCoordinate2D {
        switch location {
        case place.home:
            return HOME_COORDINATE
        case place.manyata_d3:
            return MANYATA_D3_COORDINATE
        case place.manyata_escape:
            return MANAYATA_ESCAPE_COORDINATE
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
        if isAuthorizedToNotify() {
            notifyUser(title: "Entering", subtitle: "Monitored region", body: "You are entering the monitored region \(region.identifier)",region: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit")
        if isAuthorizedToNotify() {
            notifyUser(title: "Exiting", subtitle: "Monitored region", body: "You are exiting the monitored region \(region.identifier)", region: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("started monitoring for region: \(region.identifier)")
        // what else can we do here?
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        
    }
    
    // MARK: Local notification
    
    func requestNotificationPermission() {// generally in application:didFinishLaunchingWithOptions:
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {(granted, error) in
            if granted {
                print("notif success")
            } else {
                print("notif error")
            }
        })
    }
    
    func isAuthorizedToNotify() -> Bool {
        var isAuthorized = false
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: {settings in
            if settings.authorizationStatus == .authorized {// authorizedAlways, authorizedWhenInUse
                isAuthorized = true
            }
        })
        return isAuthorized
    }
    
    func notifyUser(title: String, subtitle: String, body: String, region: CLRegion) {
        let notification = configLocalNotification(title: title, subtitle: subtitle, body: body)
        triggerLocalNotification(notification: notification, region: region)
    }
    
    func configLocalNotification(title: String, subtitle: String, body: String) -> UNMutableNotificationContent {
        let notification = UNMutableNotificationContent()
        notification.title = title
        notification.subtitle = subtitle
        notification.body = body
        notification.sound = UNNotificationSound.default()
        notification.badge = 1// how to increase/decrease?
        return notification
    }
    
    func triggerLocalNotification(notification: UNMutableNotificationContent, region: CLRegion) {
        let locationNotificationTrigger = UNLocationNotificationTrigger(region: region, repeats: true)
        let request = UNNotificationRequest(identifier: "no1", content: notification, trigger: locationNotificationTrigger)//identifier needs to be unique
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            print(error.debugDescription)
        })
    }
    
    func dummyNotification(title: String, subtitle: String, body: String) {
        let notification = configLocalNotification(title: title, subtitle: subtitle, body: body)
        let intervalNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // repeats false : Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'time interval must be at least 60 if repeating'
        let request = UNNotificationRequest(identifier: "no1", content: notification, trigger: intervalNotificationTrigger)//identifier needs to be unique
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            print(error.debugDescription)
        })
    }
    
}
