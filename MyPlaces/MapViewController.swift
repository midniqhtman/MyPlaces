//
//  MapViewController.swift
//  MyPlaces
//
//  Created by Байсаев Зубайр on 25.08.2022.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var place = Place()
    let annotationIdentifier = " "
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        mapView.delegate = self
        super.viewDidLoad()
        setupPlaceMark()
        checkLocationServices()

    }
    
    @IBAction func closeVc() {
        dismiss(animated: true)
    }
    
    private func setupPlaceMark() {
        
        guard let location = place.location else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
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
            
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            //show alert controller
            break
        case .denied:
            //show alert controller
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            break
        @unknown default:
            print("new case is available")
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor anootation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(anootation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: anootation, reuseIdentifier: annotationIdentifier)
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
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
