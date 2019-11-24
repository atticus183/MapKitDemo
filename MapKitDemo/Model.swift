//
//  Model.swift
//  MapKitDemo
//
//  Created by Josh R on 11/23/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import Foundation
import MapKit

class MapLocation: NSObject, MKAnnotation {
    var locationName: String
    var latitude: Double
    var longitude: Double
    
    
    init(locationName: String, latitude: Double, longitude: Double) {
        self.locationName = locationName
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    var title: String? {
        get {
            return locationName
        }
    }
}
