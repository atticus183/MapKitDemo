//
//  LocationSearchCell.swift
//  MapKitDemo
//
//  Created by Josh R on 11/23/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchCell: UITableViewCell {
    
    let locationManager = LocationManager()
    
    var placemark: MKPlacemark? {
        didSet {
            guard let placemark = placemark else { return }
            locationNameLbl.text = placemark.name
            addressLbl.text = LocationManager.parseAddress(selectedItem: placemark)
            
//            if let currentLocation = locationManager.getCurrentLocation() {
//                let searchedLocation = CLLocation(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
//                let distanceBetweenLocations = LocationManager.distanceBetween(currentLocation, searchedLocation)
//                distanceLbl.text = "\(distanceBetweenLocations) mi"
//            }
            
            distanceLbl.text = "\(placemark.distanceFromCurrentLocation) mi"
        }
    }
    
    lazy var locationNameLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        return label
    }()
    
    lazy var addressLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        
        return label
    }()
    
    lazy var distanceLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .darkGray
        
        return label
    }()
    
    let locationSV: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 2
        sv.distribution = .fill
        
        return sv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addLblsToCell()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func addLblsToCell() {
        locationSV.addArrangedSubview(locationNameLbl)
        locationSV.addArrangedSubview(addressLbl)
        self.addSubview(locationSV)
        self.addSubview(distanceLbl)
    }
    
    private func addConstraints() {
        locationSV.translatesAutoresizingMaskIntoConstraints = false
        locationNameLbl.translatesAutoresizingMaskIntoConstraints = false
        addressLbl.translatesAutoresizingMaskIntoConstraints = false
        distanceLbl.translatesAutoresizingMaskIntoConstraints = false
        
        locationSV.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12).isActive = true
        locationSV.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        distanceLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -12).isActive = true
        distanceLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

}
