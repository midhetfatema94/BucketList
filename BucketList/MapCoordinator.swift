//
//  MapCoordinator.swift
//  BucketList
//
//  Created by Waveline Media on 12/30/20.
//

import Foundation
import MapKit

//Coordinators help in communicating the updates from UIKit delegates to SwiftUI Views and Properties
class MapCoordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        parent.centerCoordinate = mapView.centerCoordinate
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // this is our unique identifier for view reuse
        let identifier = "placemark"
        
        // attempt to find a cell we can recycle
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            // we didn't find one; make a new one
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)

            // allow this to show pop up information
            annotationView?.canShowCallout = true

            // attach an information button to the view
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            // we have a view to reuse, so give it the new annotation
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let placemark = view.annotation as? MKPointAnnotation else { return }

        parent.selectedPlace = placemark
        parent.alertTitle = placemark.title ?? "Missing Place"
        parent.alertMessage = placemark.subtitle
        parent.showingPlaceDetails = true
    }
}
