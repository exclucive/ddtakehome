//
//  VenuesListViewController.swift
//  DDSample
//
//  Created by Igor Novik on 2018-06-03.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit
import CoreLocation
import Kingfisher

class VenuesListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationServicesPopup: UIView!
    
    private var venues = [Venue]()
    private var currentLocation: CLLocation?
    private var locationManager: CLLocationManager?
    private var isLoadingVenues = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocationManager()
        subscribe()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        unsubscribe()
    }
    
    // MARK: Notifications
    private func subscribe(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: .UIApplicationDidBecomeActive,
                                               object: nil)
    }
    
    private func unsubscribe() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIApplicationDidBecomeActive,
                                                  object: nil)
    }

    // MARK: UI related logic
    private func configrueTableView() {
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func showActivityIndicator(_ show: Bool) {
        if show {
            let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
            let refreshBarButton = UIBarButtonItem(customView: activityIndicator)
            navigationItem.rightBarButtonItem = refreshBarButton
            activityIndicator.startAnimating()
        }
        else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    
    // MARK: Location related logic
    private func isLocationServicesEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            }
        } else {
            return false
        }
    }
    
    private func initializeLocationManager() {
        guard isLocationServicesEnabled() else {
            locationServicesPopup.isHidden = false
            tableView.isHidden = true
            return
        }
        
        locationServicesPopup.isHidden = true
        tableView.isHidden = false
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    // MARK: Helpers
    private func fetchVenues(location: CLLocation) {
        if isLoadingVenues == false {
            isLoadingVenues = true
            showActivityIndicator(true)
            VenuesFetcher.fetchVenues(forLocation: location) {[unowned self] (error, fetchedVenues) in
                self.isLoadingVenues = false
                self.showActivityIndicator(false)
                
                guard error == nil else {
                    self.presentError(error)
                    return
                }
                
                if let venues = fetchedVenues {
                    self.venues = venues
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // convert delivery time to readable format from minutes
    private func deliveryTime(minutes: Int) -> String {
        let hours = minutes / 60
        let minutes = minutes % 60
        
        var result = ""
        if hours > 0 {
            result += "\(hours) hour "
        }
        
        if minutes > 0 {
            result += "\(minutes) min"
        }
        
        return result
    }
    
    private func openMap(with location: CLLocation?) {
        let mapControllerIdentifier = String(describing: MapViewController.self)
        guard let mapController = storyboard?.instantiateViewController(withIdentifier: mapControllerIdentifier) as? MapViewController else {
            return
        }
        mapController.location = location
        mapController.delegate = self
        present(mapController, animated: true, completion: nil)
    }
    
    // MARK: Actions
    @objc func applicationDidBecomeActive() {
        if locationManager == nil {
            initializeLocationManager()
        }
        else {
            locationManager?.startUpdatingLocation()
        }
    }
    
    @IBAction func goToSettingsButtonAction(_ sender: Any) {
        if let url = NSURL(string: UIApplicationOpenSettingsURLString) as URL? {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func openMapButtonAction(_ sender: Any) {
        openMap(with: currentLocation)
    }
}

extension VenuesListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard isLocationServicesEnabled() else {
            locationServicesPopup.isHidden = false
            tableView.isHidden = true
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            return
        }
        currentLocation = lastLocation
        fetchVenues(location: lastLocation)
        manager.stopUpdatingLocation()
    }
}

extension VenuesListViewController: UITableViewDelegate, UITableViewDataSource {
    private func configure(_ venueCell: VenueTableViewCell, indexPath: IndexPath) {
        let venue = venues[indexPath.row]
        
        venueCell.venueImageView.kf.setImage(with: venue.thumbnailURL)
        venueCell.venueNameLabel.text = venue.name
        venueCell.typeOfFoodLabel.text = venue.description
        venueCell.deliveryPriceLabel.text = "$\(venue.deliveryFee) delivery"
        venueCell.deliveryTimeLabel.text = deliveryTime(minutes: venue.deliveryTime)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VenueTableViewCell.cellIdentifier,
                                                       for: indexPath) as? VenueTableViewCell else {
            return UITableViewCell()
        }
    
        configure(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension VenuesListViewController: MapViewControllerDelegate {
    func confirmedAddressWith(_ location: CLLocation) {
        dismiss(animated: true, completion: nil)
        currentLocation = location
        fetchVenues(location: location)
    }
}
