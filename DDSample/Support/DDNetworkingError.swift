//
//  DDNetworkingError.swift
//  DDSample
//
//  Created by Igor Novik on 5/31/18.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

enum DDNetworkingError: DDErrorType {
    case venuesFetchingError
    
    var code: Int {
        switch self {
        case .venuesFetchingError:
            return -10
        }
    }
    
    var title: String? {
        switch self {
        case .venuesFetchingError:
            return "Venues fetching error"
        }
    }
    
    var description: String {
        switch self {
        case .venuesFetchingError:
            return "The error occured during venues fetching downloading"
        }
    }
}
