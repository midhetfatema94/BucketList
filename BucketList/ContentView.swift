//
//  ContentView.swift
//  BucketList
//
//  Created by Waveline Media on 12/29/20.
//

import SwiftUI
import LocalAuthentication
import MapKit

struct ContentView: View {
    @State private var isUnlocked = false
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [MKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    @State private var showingEditScreen = false
    
    var body: some View {
        ZStack {
//            if self.isUnlocked {
//                Text("Unlocked")
//            } else {
//                Text("Locked")
//            }
            
            MapView(centerCoordinate: $centerCoordinate,
                    selectedPlace: self.$selectedPlace,
                    showingPlaceDetails: self.$showingPlaceDetails,
                    annotations: locations)
                .edgesIgnoringSafeArea(.all)
            
            Circle()
                .fill(Color.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        let newLocation = MKPointAnnotation()
                        newLocation.coordinate = self.centerCoordinate
                        newLocation.title = "Example location"
                        let filteredLocations = locations.first(where: { $0 == newLocation })
                        if filteredLocations == nil {
                            self.locations.append(newLocation)
                        }
                    }, label: {
                        Image(systemName: "plus")
                    })
                    .padding()
                    .background(Color.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding([.trailing, .bottom])
                }
            }
        }
//        .onAppear(perform: authenticate)
        .alert(isPresented: $showingPlaceDetails) {
            Alert(title: Text(selectedPlace?.title ?? "Unknown"), message: Text(selectedPlace?.subtitle ?? "Missing place information."), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Edit")) {
                self.showingEditScreen = true
            })
        }
        .sheet(isPresented: $showingEditScreen) {
            if let place = self.selectedPlace {
                EditView(placemark: place)
            }
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                DispatchQueue.main.async {
                    if success {
                        // authenticated successfully
                    } else {
                        // there was a problem
                    }
                }
            }
        } else {
            // no biometrics
        }
    }
}

extension MKPointAnnotation: Comparable {
    public static func < (lhs: MKPointAnnotation, rhs: MKPointAnnotation) -> Bool {
        return lhs.coordinate.latitude < rhs.coordinate.latitude && lhs.coordinate.longitude < rhs.coordinate.longitude
    }
    
    public static func == (lhs: MKPointAnnotation, rhs: MKPointAnnotation) -> Bool {
        return lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
