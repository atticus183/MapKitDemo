//
//  Extensions.swift
//  MapKitDemo
//
//  Created by Josh R on 11/23/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import Foundation
import MapKit


extension Double {
    func convert(fromUnit: UnitLength, toUnit: UnitLength, roundTo: Int) -> (Double, String) {
        let inputValue = Measurement(value: self, unit: fromUnit)
        let convertedAmount = inputValue.converted(to: toUnit)
        
        var stringToUnit: String!
        
        switch toUnit {
        case UnitLength.miles:
            stringToUnit = "miles"
        case UnitLength.kilometers:
            stringToUnit = "kilometers"
        case UnitLength.meters:
            stringToUnit = "meters"
        case UnitLength.centimeters:
            stringToUnit = "centimeters"
        case UnitLength.millimeters:
            stringToUnit = "millimeters"
        case UnitLength.inches:
            stringToUnit = "inches"
        case UnitLength.feet:
            stringToUnit = "feet"
        case UnitLength.yards:
            stringToUnit = "yards"
        default:
            stringToUnit = "N/A"
        }
        
        let roundedMeasurement = convertedAmount.value.roundTo(numberOfDigits: roundTo)
        return (roundedMeasurement, "\(roundedMeasurement) \(stringToUnit!)")
    }
    
    func roundTo(numberOfDigits: Int) -> Double {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = numberOfDigits
        numberFormatter.maximumFractionDigits = numberOfDigits
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "en_US")
        
        let convertedNumber = self as NSNumber
        guard let stringNumber = numberFormatter.string(from: convertedNumber) else { return self }
        let cleanedNumber = stringNumber.replacingOccurrences(of: ",", with: "").toDouble()

        return cleanedNumber
    }
}

extension String {
    func toDouble() -> Double {
        guard let unwrappedDouble = Double(self.replacingOccurrences(of: ",", with: "")) else { return 0.0 }
        return unwrappedDouble
    }
}


extension MKPlacemark {
    var distanceFromCurrentLocation: Double {
        if let currentLocation = LocationManager().getCurrentLocation() {
            let searchedLocation = CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
            let distanceBetweenLocations = LocationManager.distanceBetween(currentLocation, searchedLocation)
            
            return distanceBetweenLocations
        } else {
            return 0.0
        }
    }
}
