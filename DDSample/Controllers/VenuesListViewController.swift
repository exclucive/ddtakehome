//
//  VenuesListViewController.swift
//  DDSample
//
//  Created by Igor Novik on 2018-06-03.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit
import CoreLocation

class VenuesListViewController: UIViewController {
    private var currentLocation: CLLocation = CLLocation(latitude: 37.7834364, longitude: -122.40803770000002)
    
    @IBOutlet weak var tableView: UITableView!
    
    private var venues = [Venue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VenuesFetcher.fetchVenues(forLocation: currentLocation) {[unowned self] (error, fetchedVenues) in
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    private func presentError(_ error: Error?) {
        guard let error = error else {
            return
        }
        
        let errorAlertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        self.present(errorAlertController, animated: true, completion: nil)
    }
    
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
}

extension VenuesListViewController: UITableViewDelegate, UITableViewDataSource {
    private func configure(_ venueCell: VenueTableViewCell, indexPath: IndexPath) {
        let venue = venues[indexPath.row]
        
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
}
