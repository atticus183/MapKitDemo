//
//  MapSearchVC.swift
//  MapKitDemo
//
//  Created by Josh R on 11/22/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch: class {
    func passLocation(mapItem: MKMapItem)
}

class MapSearchVC: UITableViewController {
    
    fileprivate let cellID = "SearchCell"
    let locationManager = LocationManager()
    
    var matchingItems: [MKMapItem] = []
    var regionToSearch: MKCoordinateRegion?
    
    weak var handleMapSearchDelegate: HandleMapSearch? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(LocationSearchCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
    }
    
    
    
}

extension MapSearchVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO: configure custom cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? LocationSearchCell else { return UITableViewCell(
            ) }
        
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.placemark = selectedItem
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapItem = matchingItems[indexPath.row]
        handleMapSearchDelegate?.passLocation(mapItem: mapItem)
        dismiss(animated: true, completion: nil)
    }
}


extension MapSearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let regionToSearch = regionToSearch,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText.lowercased()
        request.region = regionToSearch
        let search = MKLocalSearch(request: request)
        
        search.start { [weak self] response, _ in
            guard let response = response else {
                return
            }
            self?.matchingItems = response.mapItems.sorted(by: { $0.placemark.distanceFromCurrentLocation < $1.placemark.distanceFromCurrentLocation })
            self?.tableView.reloadData()
        }
    }
    
}
