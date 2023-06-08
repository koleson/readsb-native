//
//  AircraftPosition.swift
//  readsb-native
//
//  Created by Kiel Oleson on 4/17/23.
//

import Foundation
import MapKit

// struct AircraftPosition: Identifiable {
//    var id = UUID()
//    let flight: AircraftMeta
//    let coordinate: CLLocationCoordinate2D
// }

extension AircraftMeta {
    var location: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon)
    }
}

extension AircraftMeta: Identifiable {
    var id: UInt32 { addr }
}
