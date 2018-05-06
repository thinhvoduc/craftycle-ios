//
//  LocationPickerViewController.swift
//  Craftycle
//
//  Created by Thinh Vo on 05/05/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol LocationPickerViewControllerDelegate: NSObjectProtocol {
    func locationPickerViewController(_ viewController: UIViewController, didSelectPlacemark placemark: CLPlacemark)
}


class LocationPickerViewController: UIViewController {
    
    /// MapView
    lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsUserLocation = true
        return view
    }()
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    lazy var locationResultsViewController: LocationResultsViewController = {
        let controller = LocationResultsViewController()
        controller.delegate = self
        return controller
    }()
    
    lazy var searchController: UISearchController = {
        let vcc = UIViewController()
        vcc.view.backgroundColor = .black
        let controller = UISearchController(searchResultsController: locationResultsViewController)
        controller.dimsBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = true
        controller.obscuresBackgroundDuringPresentation = true
        controller.searchResultsUpdater = locationResultsViewController
        return controller
    }()
    
    /// Delegate
    weak var delegate: LocationPickerViewControllerDelegate?
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        configureLocation()
        
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Location
        
    }
    
    // MARK: - Helper methods
    func setUp() {
        view.backgroundColor = .white
        
        // Search View
        view.addSubview(mapView)
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        // Search Bar
        navigationItem.searchController = searchController
    }
    
    fileprivate func configureLocation() {
        if !CLLocationManager.locationServicesEnabled() {
            notifyLocationServiceUnavailability()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    fileprivate func notifyLocationServiceUnavailability() {
        let aletController = UIAlertController(title: "Location Service Is Disabled", message: "Please turn on location service!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        aletController.addAction(okAction)
        
        present(aletController, animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate methods
extension LocationPickerViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            manager.stopUpdatingLocation()
        }
    }
}

// MARK: - LocationResultsViewControllerDelegate methods
extension LocationPickerViewController: LocationResultsViewControllerDelegate {
    func locationResultsViewController(_ controller: UIViewController, didSelectPlaceMark placemark: CLPlacemark) {
        delegate?.locationPickerViewController(self, didSelectPlacemark: placemark)
        navigationController?.popViewController(animated: true)
    }
}

extension LocationPickerViewController: UISearchControllerDelegate {
    
}
