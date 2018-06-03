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

class MapViewController: UIViewController {
    private var locationManager: CLLocationManager?
    private var currentLocation: CLLocation = CLLocation(latitude: 37.7834364, longitude: -122.40803770000002)
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareMap()
            
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
        mapView.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func mapViewTapped(gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        addPin(at: coordinate)
    }

    func addPin(at coordiante: CLLocationCoordinate2D) {
        let newAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = coordiante
        
        mapView.addAnnotation(newAnnotation)
    }
    
    // MARK: Helpers
    private func initialiaeLocationManager() {
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location services are not enabled")
            return
        }

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.stopUpdatingLocation()
    }

    private func prepareMap() {
        mapView.delegate = self
        
        let regionRadius: CLLocationDistance = 1000
        centerMapOnLocation(location: currentLocation, radius: regionRadius)
    }
    
    func centerMapOnLocation(location: CLLocation, radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, radius, radius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            return
        }
        
        currentLocation = lastLocation
    }
}

extension MapViewController: MKMapViewDelegate {

}

