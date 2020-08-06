//
//  MapViewController.swift
//  Places App
//
//  Created by Eugene Kiselev on 06.08.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var place: Place!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPlacemark()
    }
    
    @IBAction func closeMapViewController() {
        
        dismiss(animated: true)
    }
    
    private func setupPlacemark() {
        
        guard let location = place.location else { return  }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            
            if let error = error {
                print(error)
                return
            }
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            
            let annotation =  MKPointAnnotation()
            annotation.title = self.place.name
            annotation.subtitle = self.place.type
            
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
}
