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
    @State private var locations = [CodableMKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingEditScreen = false
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage: String?
    
    var body: some View {
        ZStack {
            if self.isUnlocked {
                MapView(centerCoordinate: $centerCoordinate,
                        selectedPlace: self.$selectedPlace,
                        showingPlaceDetails: self.$showAlert,
                        alertTitle: self.$alertTitle,
                        alertMessage: self.$alertMessage,
                        annotations: locations)
                    .edgesIgnoringSafeArea(.all)
                
                Circle()
                    .fill(Color.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                
                FloatingButton(centerCoordinate: $centerCoordinate,
                               locations: $locations)
                
            } else {
                Button(action: authenticate, label: {
                    Text("Unlock Places")
                })
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage ?? "Missing place information."), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Edit")) {
                self.showingEditScreen = true
            })
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: saveData) {
            if let place = self.selectedPlace {
                EditView(placemark: place)
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    func loadData() {
        let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
        do {
            let data = try Data(contentsOf: filename)
            locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
        } catch {
            print("Unable to load saved data.")
        }
    }
    
    func saveData() {
        do {
            let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
            let data = try JSONEncoder().encode(self.locations)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            print("Pin data saved")
        } catch {
            print("Unable to save data.")
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "Please authenticate yourself to unloack your places"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                        self.loadData()
                    } else {
                        self.isUnlocked = false
                        self.alertTitle = "Authentication Failed"
                        self.alertMessage = "The biometrics could not be authenticated"
                        self.showAlert = true
                    }
                }
            }
        } else {
            // no biometrics
            self.isUnlocked = true
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
