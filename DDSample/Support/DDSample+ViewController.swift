//
//  ViewController.swift
//  DDSample
//
//  Created by Igor Novik on 2018-06-03.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentError(_ error: Error?) {
        guard let error = error else {
            return
        }
        
        let errorAlertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        self.present(errorAlertController, animated: true, completion: nil)
    }

}
