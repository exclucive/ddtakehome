//
//  ViewController.swift
//  DDSample
//
//  Created by Igor Novik on 2018-06-03.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol MapViewControllerDelegate: class {
    func confirmedAddressWith(_ location: CLLocation)
}

class MapViewController: UIViewController {
    //
    var location: CLLocation?
    weak var delegate: MapViewControllerDelegate?
    
    //
    private let regionRadius: CLLocationDistance = 1000
    private var geocoder: CLGeocoder = CLGeocoder()
    
    //
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBar()
        prepareMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UI related logic
    private func addNavigationBar() {
        let navigationBarLabel = UILabel()
        navigationBarLabel.text = "Choose an Address"
        navigationBarLabel.font = Constants.Apperance.navBarTitleFont
        
        let standaloneItem = UINavigationItem()
        standaloneItem.titleView = navigationBarLabel
        
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: 44))
        navigationBar.isTranslucent = false
        navigationBar.delegate = self
        navigationBar.backgroundColor = .white
        navigationBar.items = [standaloneItem]
        view.addSubview(navigationBar)
        
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    
    // MARK: Helpers
    private func prepareMap() {
        mapView.showsUserLocation = true
        mapView.delegate = self
        guard let currentLocation = location else {
            return
        }
        centerMapOnLocation(location: currentLocation, radius: regionRadius)
    }
    
    
    func centerMapOnLocation(location: CLLocation, radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, radius, radius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: Actions
    @IBAction func confirmAddressButtonAction(_ sender: Any) {
        let addressCoordinate = mapView.centerCoordinate
        let location = CLLocation(latitude: addressCoordinate.latitude,
                                  longitude: addressCoordinate.longitude)
        delegate?.confirmedAddressWith(location)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        self.addressTextField.text = "Loading..."
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) {[unowned self] (placemarks, error) in
            guard error == nil else {
                self.presentError(error)
                return
            }
            
            guard let address = placemarks?.first?.name else {
                return
            }
            
            self.addressTextField.text = address
        }
    }
}

extension MapViewController: UINavigationBarDelegate {
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}


