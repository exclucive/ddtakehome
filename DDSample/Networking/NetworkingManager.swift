//
//  NetworkingManager.swift
//  DDSample
//
//  Created by Igor Novik on 2018-06-03.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

class NetworkingManager: NSObject {
    private static let baseURL = "https://api.doordash.com/"
    
    // MARK: Private
    private class func session() -> URLSession {
        return URLSession.shared
    }
    
    private class func request(_ endpoint: String, parameters: [String: String]) -> URLRequest? {
        guard let url = URL(string: baseURL + endpoint) else {
            return nil
        }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        urlComponents?.queryItems = parameters.map { (parameter) -> URLQueryItem in
            return URLQueryItem(name: parameter.key, value: parameter.value)
        }
        guard let requestUrl = urlComponents?.url else {
            return nil
        }
        
        return URLRequest(url: requestUrl)
    }
    
    // MARK: Public
    class func getRequest(_ endpoint: String,
                          parameters: [String: String],
                          completionHandler: @escaping (Error?, Data?) -> ()) {
        
        guard let request = request(endpoint, parameters: parameters) else {
            DispatchQueue.main.async {
                let error = DDError(errorType: DDNetworkingError.venuesFetchingError)
                completionHandler(error, nil)
            }
            
            return
        }
        
        session().dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completionHandler(error, data)
            }
            }.resume()
    }

}
