//
//  MapView.swift
//  DynamicSource_iOS
//
//  Created by Hasan Dag on 16.05.2023.
//

import SwiftUI
import MapKit
import CoreLocation

protocol MapViewClickDelegate {
    func userClicked(coordiante : CLLocationCoordinate2D)
}

struct MapView: UIViewRepresentable {
    
    var coordinate: CLLocationCoordinate2D
    
    var onClickDelegate : MapViewClickDelegate?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.mapType = .satelliteFlyover
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        annotation.title = "WARSAW CHOPIN"
        DispatchQueue.main.async {
            view.setRegion(region, animated: true)
            view.removeAnnotations(view.annotations)
            view.addAnnotation(annotation)
        }
    }
    
    // MARK: -Coordinator
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard annotation is MKPointAnnotation else { return nil }
            
            let identifier = "Annotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                let button = UIButton(type: .detailDisclosure)
                annotationView?.rightCalloutAccessoryView = button
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            if let annotation = view.annotation as? MKPointAnnotation, let delegate = parent.onClickDelegate {
                delegate.userClicked(coordiante: annotation.coordinate)
            }
        }
    }
    
}

