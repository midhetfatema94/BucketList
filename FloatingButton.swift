//
//  FloatingButton.swift
//  BucketList
//
//  Created by Waveline Media on 12/30/20.
//

import SwiftUI
import MapKit

struct FloatingButton: View {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var locations: [CodableMKPointAnnotation]
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(action: addNewPin, label: {
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
    
    func addNewPin() {
        let newLocation = CodableMKPointAnnotation()
        newLocation.coordinate = self.centerCoordinate
        newLocation.title = "Example location"
        let filteredLocations = locations.first(where: { $0 == newLocation })
        if filteredLocations == nil {
            self.locations.append(newLocation)
        }
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButton(centerCoordinate: .constant(MKPointAnnotation.example.coordinate), locations: .constant([MKPointAnnotation.example]))
    }
}
