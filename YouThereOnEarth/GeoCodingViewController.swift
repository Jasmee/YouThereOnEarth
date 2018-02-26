//
//  GeoCodingViewController.swift
//  YouThereOnEarth
//
//  Created by Jasmee Sengupta on 21/02/18.
//  Copyright © 2018 Jasmee Sengupta. All rights reserved.
//  Geocode - get coordinates (lat-long) from an address and reverse geocode - get address from lat-long


import Foundation
import MapKit

class GeoCodingViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let latitude = 12.9602547
    let longitude = 77.58870290000004
    let latitudeDelta = 0.05
    let longitudeDelta = 0.05
    let name = "APlaceOnEarth"
    let address = "4th H Cross Road 6, Sudhama Nagar, Bengaluru, Karnataka, 560002, India"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getPlaceNameFromCoordinate()
        getCoordinateFromPlaceName()
    }
    // TODO: Forward and reverse segmented control, with dynamic value
    
    // MARK: Geocoding
    // Reverse geocoding
    func getPlaceNameFromCoordinate() {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        setUpMapView(location: location, latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        dropAPin(location: location, name: name, address: address)
        geoCoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if error != nil {
                print("Error")
                return
            }
            if let placemarks = placemarks {
                if placemarks.count > 0 {
                    print("Got \(placemarks.count) placemarks")
                    print(placemarks[0])
                    
                    for place in placemarks {
                        var address = [String] ()
                        if let name = place.name {
                            address.append(name)
                        }
                        if let subLocality = place.subLocality {
                            address.append(subLocality)
                        }
                        if let locality = place.locality {
                            address.append(locality)
                        }
                        if let administrativeArea = place.administrativeArea {
                            address.append(administrativeArea)
                        }
                        if let postalCode = place.postalCode {
                            address.append(postalCode)
                        }
                        if let country = place.country {
                            address.append(country)
                        }
                        print(address)
                        print((address.map{String($0)}).joined(separator: ", "))
                        if let timeZone = place.timeZone {
                            print(timeZone)
                        }
                        if let areasOfInterest = place.areasOfInterest {
                            print(areasOfInterest)
                        }
                    }
                }
            }
        })
    }
    
    // Forward geocoding
    func getCoordinateFromPlaceName() {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address, completionHandler: {(placemarks, error) in
            if error != nil {
                print(error.debugDescription)
            }
            if let placemarks = placemarks {
                if placemarks.count > 0 {
                    for place in placemarks {
                        print(place)
                        guard let location = place.location else {
                            return
                        }
                        print("Latitude : \(location.coordinate.latitude), longitude: \(location.coordinate.longitude)")
                        self.setUpMapView(location: location, latitudeDelta: self.latitudeDelta, longitudeDelta: self.longitudeDelta)
                        self.dropAPin(location: location, name: self.name, address: self.address)
                    }
                }
            }
        })
    }
    
    // MARK: Utilities
    
    func setUpMapView(location: CLLocation, latitudeDelta: Double, longitudeDelta: Double) {
        mapView.mapType = .standard
        let location = location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func dropAPin(location: CLLocation, name title: String, address subtitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = title
        annotation.subtitle = subtitle
        mapView.addAnnotation(annotation)
    }

}
