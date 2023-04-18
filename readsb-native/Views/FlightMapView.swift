//
//  FlightMapView.swift
//  readsb-native
//
//  Created by Kiel Oleson on 4/17/23.
//

import SwiftUI
import MapKit

struct FlightMapView: View {
    // centered on Sonoma Mountain for now
    @State var visibleRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38.32305157159416, longitude: -122.57477949843941), latitudinalMeters: 60_000.0, longitudinalMeters: 60_000.0)
    
    private func color(forAltitude altitude: Int32) -> Color {
        let maxColorAltitude = 60_000
        let proportion: Double = Double(altitude) / Double(maxColorAltitude)
        let color = Color(hue: proportion, saturation: 1.0, brightness: 1.0)
        return color
    }
    
    var aircraftMarkers: [AircraftPosition]
    
    var body: some View {
        Map(coordinateRegion: $visibleRegion,
            interactionModes: [.all], showsUserLocation: false, userTrackingMode: nil, annotationItems: aircraftMarkers) { aircraft in
            MapAnnotation(coordinate: aircraft.coordinate) {
                VStack {
                    Image(systemName: "airplane")
                        .rotationEffect(.degrees(Double(aircraft.flight.navHeading)))
                        .foregroundColor(color(forAltitude: aircraft.flight.altGeom))
                        .onTapGesture {
                            print("tapped plane \(aircraft.flight.flight)")
                            // selected.insert(<#T##newMember: AircraftMeta##AircraftMeta#>)
                        }
                        .onHover { inFrame in
                            if inFrame {
                                print("hovering over plane \(aircraft.flight.flight)")
                            } else {
                                print("hover exited \(aircraft.flight.flight)")
                            }
                        }
                    VStack(alignment: .leading) {
                        Text("\(aircraft.flight.flight)")
                        Text("ALT: \(aircraft.flight.altBaro) ft")
                        Text("GS: \(aircraft.flight.gs) kts")
                    }
                    .padding(6.0)
                    .background(Color.black.opacity(0.3)).cornerRadius(3.0)
                    //.border(.black, width: selected.contains(aircraft) ? 0.0 : 2.0)
                }
                
            }
        }
    }
}

struct FlightMapView_Previews: PreviewProvider {
    static var previews: some View {
        // TODO:  improve preview
        FlightMapView(aircraftMarkers: [])
    }
}
