//
//  LocationManager.swift
//  MapKitDemo
//
//  Created by Josh R on 11/22/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import Foundation
import MapKit

enum RadiusZoom: Double {
    case reallyClose = 100
    case close = 200
    case medium = 1000
    case far = 5000
    case somewhatFar = 50000
    case reallyFar = 100000
}


class LocationManager {
    
    let locationManager = CLLocationManager()
    
    static let rochMN = CLLocation(latitude: 44.0121, longitude: -92.4802)
    
    
    func isLocationServicesEnabled() -> Bool {
        var isLocationServicesEnabled = false
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            isLocationServicesEnabled = true
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
        
        return isLocationServicesEnabled
    }
    
    
    func checkLocationAuthorization(in mapView: MKMapView) {
        //NOTE: add "Privacy - Location When In Use Usage Description" to your PList along with a description.
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            fatalError()
        }
    }
    
    func getCurrentLocation() -> CLLocation? {
        if CLLocationManager.locationServicesEnabled() {
            return locationManager.location
        } else {
            return nil
        }
    }
    
    func setupRegion(location: CLLocationCoordinate2D?, orAt selectedLocationPlacemark: MKPlacemark?, radius: RadiusZoom, mapView: MKMapView) {
        
        var region: MKCoordinateRegion?
        
        if let location = location {
            region = MKCoordinateRegion.init(center: location, latitudinalMeters: radius.rawValue, longitudinalMeters: radius.rawValue)
        }
        
        if let selectedLocationPlacemark = selectedLocationPlacemark {
            region = MKCoordinateRegion.init(center: selectedLocationPlacemark.coordinate, latitudinalMeters: radius.rawValue, longitudinalMeters: radius.rawValue)
        }
        
        if let region = region {
            mapView.setRegion(region, animated: true)
        }
    }
    
    func setupPin(in mapView: MKMapView, at selectedLocation: CLLocationCoordinate2D?, orAt selectedLocationPlacemark: MKPlacemark?, pinName: String?) {
        //remove existing pins
        mapView.removeAnnotations(mapView.annotations)
        
        //Setup normal pin
//        if let selectedLocation = selectedLocation {
//            let newPin = MKPointAnnotation()
//            newPin.title = pinName ?? "New Location"
//            newPin.coordinate = selectedLocation
//            mapView.addAnnotation(newPin)
//        }
        
        //set up MKPlacemark pin
        if let selectedLocationPlacemarked = selectedLocationPlacemark {
            let annotation = MKPointAnnotation()
            annotation.coordinate = selectedLocationPlacemarked.coordinate
            annotation.title = selectedLocationPlacemarked.name
            if let city = selectedLocationPlacemarked.locality,
                let state = selectedLocationPlacemarked.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
            }
            
            mapView.addAnnotation(annotation)
        }
        
    }
    
    
    func removeMapPin(mapView: MKMapView) {
         mapView.removeAnnotations(mapView.annotations)
    }
    
    static func parseAddress(selectedItem: MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
    
    static func distanceBetween(_ startingLocation: CLLocation, _ endingLocation: CLLocation) -> Double {
        let distanceInMeters = startingLocation.distance(from: endingLocation)
        
        //Convert to miles, round to one decimal place
        let distanceDouble = Double(distanceInMeters).convert(fromUnit: .meters, toUnit: .miles, roundTo: 1)
        
        return distanceDouble.0
    }

}
