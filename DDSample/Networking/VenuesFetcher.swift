//
//  VenuesFetcher.swift
//  DDSample
//
//  Created by Igor Novik on 2018-06-03.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit
import CoreLocation

class VenuesFetcher: NSObject {
    private static let fetchVenues = "v1/store_search/"
    
    private class func parse(_ data: Data?, completionHandler: @escaping (Error?, [Venue]?) -> ()) {
        // unwrap optional response
        guard let responseData = data else {
            let error = DDError(errorType: DDNetworkingError.venuesFetchingError)
            completionHandler(error, nil)
            return
        }
        
        // parse response into model objects
        do {
            let venues = try JSONDecoder().decode([Venue].self, from: responseData)
            completionHandler(nil, venues)
        }
        catch let error {
            completionHandler(error, nil)
        }
    }
    
    // MARK: Public methods
    class func fetchVenues(forLocation location: CLLocation, completionHandler: @escaping (Error?, [Venue]?) -> ()) {
        let parameters = ["lat": "\(location.coordinate.latitude)", "lng": "\(location.coordinate.longitude)"]
        NetworkingManager.getRequest(fetchVenues, parameters: parameters) { (error, responseData) in
            guard error == nil else {
                completionHandler(error, nil)
                return
            }
            
            // parse
            parse(responseData, completionHandler: completionHandler)
        }
    }
}
