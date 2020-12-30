//
//  MKPointAnnotation-Codable.swift
//  BucketList
//
//  Created by Waveline Media on 12/30/20.
//

import Foundation
import MapKit

class CodableMKPointAnnotation: MKPointAnnotation, Codable {
    enum CodingKeys: CodingKey {
        case title, subtitle, latitude, longitude
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decode(String.self, forKey: .subtitle)
        let lat = try container.decode(String.self, forKey: .latitude)
        let long = try container.decode(String.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat) ?? 0, longitude: CLLocationDegrees(long) ?? 0)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(subtitle, forKey: .subtitle)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
}
