//
//  MapView.swift
//  BucketList
//
//  Created by Waveline Media on 12/29/20.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingPlaceDetails: Bool
    
    var annotations: [MKPointAnnotation]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        //Binding the delegate of this view to the updates from the coordinator
        mapView.delegate = context.coordinator
        
//        let annotation = MKPointAnnotation()
//        annotation.title = "London"
//        annotation.subtitle = "Capital of England"
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: 0.13)
//        mapView.addAnnotation(annotation)
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        if annotations.count != view.annotations.count {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(self)
    }
}

extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Home to the 2012 Summer Olympics."
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
        return annotation
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(centerCoordinate: .constant(MKPointAnnotation.example.coordinate), annotations: [MKPointAnnotation.example])
//    }
//}
