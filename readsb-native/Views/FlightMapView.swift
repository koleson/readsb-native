//
//  FlightMapView.swift
//  readsb-native
//
//  Created by Kiel Oleson on 4/17/23.
//

import SwiftUI
import MapKit
import OSLog

struct FlightMapView: View {
    let logger = Logger(subsystem: "FlightMapView", category: "interaction")

    // centered on Sonoma Mountain for now
    private static let sonomaMountain = CLLocationCoordinate2D(
        latitude: 38.32305157159416,
        longitude: -122.57477949843941)

    @State var visibleRegion = MKCoordinateRegion(
        center: sonomaMountain,
        latitudinalMeters: 60_000.0,
        longitudinalMeters: 60_000.0)

    private func color(forAltitude altitude: Int32) -> Color {
        let maxColorAltitude = 60_000
        let proportion: Double = Double(altitude) / Double(maxColorAltitude)
        let color = Color(hue: proportion, saturation: 1.0, brightness: 1.0)
        return color
    }

    var aircraft: [AircraftMeta]

    var body: some View {
        Map(coordinateRegion: $visibleRegion,
            interactionModes: [.all],
            showsUserLocation: false,
            userTrackingMode: nil,
            annotationItems: aircraft) { aircraft in
            MapAnnotation(coordinate: aircraft.location) {
                VStack {
                    Image(systemName: "airplane")
                    // have to subtract 90° from heading because icon defaults
                    // to 90° heading at 0° rotation
                        .rotationEffect(.degrees(Double(aircraft.track - 90)))
                        .foregroundColor(color(forAltitude: aircraft.altGeom))
                        .onTapGesture {
                            logger.notice("tapped plane \(aircraft.flight, privacy: .public)")
                            // selected.insert(<#T##newMember: AircraftMeta##AircraftMeta#>)
                        }
                        .onHover { inFrame in
                            if inFrame {
                                logger.info("hovering over plane \(aircraft.flight, privacy: .public)")
                            } else {
                                logger.info("hover exited \(aircraft.flight, privacy: .public)")
                            }
                        }
                    VStack(alignment: .leading) {
                        Text("\(aircraft.flight)")
                        Text("ALT: \(aircraft.altBaro) ft")
                        Text("GS: \(aircraft.gs) kts")
                    }
                    .padding(6.0)
                    .background(Color.black.opacity(0.3)).cornerRadius(3.0)
                    // .border(.black, width: selected.contains(aircraft) ? 0.0 : 2.0)
                }
            }
        }
    }
}

struct FlightMapView_Previews: PreviewProvider {
    static var previews: some View {
        // TODO:  improve preview
        FlightMapView(aircraft: GlobalPreviewData.aircraftsUpdate.aircraft)
    }
}
