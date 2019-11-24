//
//  CustomMKMarkerSubclass.swift
//  MapKitDemo
//
//  Created by Josh R on 11/23/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import UIKit
import MapKit

class CustomMKMarkerSubclass: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            if let _ = newValue as? MapLocation {
                displayPriority = MKFeatureDisplayPriority.required
                canShowCallout = true
            }
        }
    }
}
