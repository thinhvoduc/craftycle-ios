//
//  LocationResultsViewController.swift
//  Craftycle
//
//  Created by Thinh Vo on 06/05/2018.
//  Copyright © 2018 Craftycle. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

enum SearchState: Int {
    case initial = 0
    case loading
    case loaded
    case error
}

protocol LocationResultsViewControllerDelegate: NSObjectProtocol {
    func locationResultsViewController(_ controller: UIViewController, didSelectPlaceMark placemark: CLPlacemark)
}

class LocationResultsViewController: UIViewController, UISearchResultsUpdating {
    
    /// Searching's state
    var state: SearchState = .initial
    
    /// Delegate
    var delegate: LocationResultsViewControllerDelegate?
    
    /// TableView
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    /// Timer
    private var timer: Timer?
    
    /// Placemarks
    private var placemarks: [CLPlacemark]?
    
    /// GeoCoder
    private let geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
        setUp()
    }
    
    // MARK: - Helper methods
    fileprivate func setUp() {
        // TableView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    fileprivate func searchLocations(_ name: String) {
        state = .loading
        geoCoder.geocodeAddressString(name, in: nil) {[weak self] (placemarks, error) in
            guard let strongSelf = self else { return }
            
            if error != nil {
                strongSelf.state = .error
                
                return
            }
            
            strongSelf.state = .loaded
            strongSelf.placemarks = placemarks
            strongSelf.tableView.reloadData()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        timer?.invalidate()
        
        guard let searchKey = searchController.searchBar.text else {
            state = .initial
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: {[weak self] (_) in
            self?.searchLocations(searchKey)
        })
    }
    

}

extension LocationResultsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placemarks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = placemarks?[indexPath.row].title
    
        return cell
    }
}

extension LocationResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let placemark = placemarks?[indexPath.row] else { return }
        
        dismiss(animated: true, completion: {[weak self] in
            guard let strongSelft = self else { return }
            
            strongSelft.delegate?.locationResultsViewController(strongSelft, didSelectPlaceMark: placemark)
        })
    }
}
