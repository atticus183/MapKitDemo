//
//  ViewController.swift
//  MapKitDemo
//
//  Created by Josh R on 11/22/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    let locationManager = LocationManager()
    var resultSearchController: UISearchController? = nil
    var annotationView = MKMarkerAnnotationView()
    var selectedMapItem: MKMapItem?
    let annotationViewID = "markerViewID"
    let annotationViewID2 = "markerViewID2"
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.checkLocationAuthorization(in: mapView)
        setupMap()
        setupSearchTable()
    }
    
    private func setupSearchTable() {
        let locationSearchTable = MapSearchVC()
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        locationSearchTable.regionToSearch = mapView.region
        locationSearchTable.handleMapSearchDelegate = self
        
        //Setup searchBar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.barStyle = .default
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
    }
    
    private func setMapConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: 0).isActive = true
    }
    
    private func setupMap() {
        locationManager.setupRegion(location: locationManager.getCurrentLocation()?.coordinate, orAt: nil, radius: RadiusZoom.medium, mapView: mapView)
        
        //MARK:  MapView register custom subclass MKMarkerAnnotationView
        mapView.register(CustomMKMarkerSubclass.self, forAnnotationViewWithReuseIdentifier: annotationViewID)
        
        mapView.delegate = self
        self.view.addSubview(mapView)
        
        setMapConstraints()
    }
    
    
}

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //cast the annotation to the custom class that subclasses NSObject and conforms to the MKAnnotation protocol
        guard let annotation = annotation as? MapLocation else { return nil }
        
        //create a property of a subclass of MKMarkerAnnotationView
        var markerView: CustomMKMarkerSubclass
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationViewID)
            as? CustomMKMarkerSubclass {
            dequeuedView.annotation = annotation
            dequeuedView.markerTintColor = .orange
            markerView = dequeuedView
        } else {
            markerView = CustomMKMarkerSubclass(annotation: annotation, reuseIdentifier: annotationViewID)
            markerView.markerTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            markerView.canShowCallout = true
            markerView.calloutOffset = CGPoint(x: -5, y: 5)
            markerView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return markerView
    }
    
}


extension MapVC: HandleMapSearch {
    func passLocation(mapItem: MKMapItem) {
        selectedMapItem = mapItem
        
        if let selectedMapItem = selectedMapItem {
            //Note:  Must convert the MKMapItem to the user created class that conforms to MKAnnotation
            let name = selectedMapItem.name ?? ""
            let lat = selectedMapItem.placemark.coordinate.latitude
            let long = selectedMapItem.placemark.coordinate.longitude
            
            //MapLocation subclasses NSObject and conforms to the MKAnnotation protocol
            let mapLocation = MapLocation(locationName: name, latitude: lat, longitude: long)
            mapView.addAnnotation(mapLocation)
        }
    }

}

