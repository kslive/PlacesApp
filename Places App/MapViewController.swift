//
//  MapViewController.swift
//  Places App
//
//  Created by Eugene Kiselev on 06.08.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    var place = Place()
    let annotationIdentifier = "annotationIdentifier"
    let location = CLLocationManager()
    let regionInMeters = 10_000.00
    var incomeSegueIdentifier = ""
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapPinImage: UIImageView!
    @IBOutlet weak var currentAdressLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentAdressLabel.text = ""
        mapView.delegate = self
        setupMapView()
        checkLocationServices()
    }
    
    @IBAction func closeMapViewController() {
        
        dismiss(animated: true)
    }
    
    @IBAction func centerViewInUserLocation() {
        
        showUserLocation()
    }
    
    @IBAction func donePressed() {
        
    }
    
    private func setupMapView() {
        
        if incomeSegueIdentifier == "showMap" {
            setupPlacemark()
            mapPinImage.isHidden = true
            currentAdressLabel.isHidden = true
            doneButton.isHidden = true
        }
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
    
    private func checkLocationServices() {
        
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Location are Disabled", message: "Settings -> Privacy -> Location Services and turn On")
            }
        }
    }
    
    private func setupLocationManager() {
        
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            
            if incomeSegueIdentifier == "getAdress" {
                showUserLocation()
            }
            break
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Location is not Availtble", message: "Settings -> Places App -> Location")
            }
            break
        case .notDetermined:
            location.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("New case")
        }
    }
    
    private func showUserLocation() {
        
        if let location = location.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    private func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
    
        if let imageData = place.imageData {
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            
            annotationView?.rightCalloutAccessoryView = imageView
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(center) { (placemarks, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            let streetName = placemark?.thoroughfare
            let buildNumber = placemark?.subThoroughfare
            
            DispatchQueue.main.async {
                if streetName != nil && buildNumber != nil {
                    self.currentAdressLabel.text = "\(streetName!), \(buildNumber!)"
                } else if streetName != nil {
                    self.currentAdressLabel.text = "\(streetName!)"
                } else {
                    self.currentAdressLabel.text = ""
                }
            }
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
