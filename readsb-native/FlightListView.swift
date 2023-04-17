//
//  ContentView.swift
//  readsb-native
//
//  Created by Kiel Oleson on 4/14/23.
//

import SwiftUI
import MapKit

class FlightListViewModel {
    internal init(update: AircraftsUpdate) {
        self.update = update
        aircraftMarkers = update.aircraft.map { aircraft in
            return AircraftPosition(flight: aircraft, coordinate: CLLocationCoordinate2D(latitude: aircraft.lat, longitude: aircraft.lon))
        }
    }
    
    var update: AircraftsUpdate
    
    var aircraftMarkers: [AircraftPosition]
}


struct AircraftPosition: Identifiable {
    var id = UUID()
    let flight: AircraftMeta
    let coordinate: CLLocationCoordinate2D
}

struct FlightDetailView: View {
    var aircraft: AircraftMeta
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(aircraft.flight)").font(.largeTitle).multilineTextAlignment(.leading)
                Spacer()
                Text(String(format: "%x", aircraft.addr)).monospaced()
            }
            
            Spacer().frame(height: 4.0)
            // squawk field needs work / conversion from octal - kmo 14 apr 2023 15h25
            // Text("Squawk: \(String(format: "%o", aircraft.squawk))")      // TODO:  octal digits, convert
            // Text("Category: \(aircraft.category)")  // hex?
            Text("Alt (Baro): \(aircraft.altBaro) feet")
            Text("Heading (Mag): \(aircraft.magHeading)°")
            Text("IAS: \(aircraft.ias)")
            Text("Lat: \(aircraft.lat)")
            Text("Lon: \(aircraft.lon)")
            Text(verbatim: String(format: "Messages: %d", aircraft.messages))
//            Text(verbatim: String(format: "Last Seen: %d ms ago", aircraft.seen))
            Spacer()
        }.padding(4.0)
    }
}

struct FlightListView: View {
    var viewModel: FlightListViewModel
    
    @State var selected: Set<AircraftMeta> = []
    
    // centered on Sonoma Mountain for now
    @State var visibleRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38.32305157159416, longitude: -122.57477949843941), latitudinalMeters: 60_000.0, longitudinalMeters: 60_000.0)
    
    private func color(forAltitude altitude: Int32) -> Color {
        let maxColorAltitude = 60_000
        let proportion: Double = Double(altitude) / Double(maxColorAltitude)
        let color = Color(hue: proportion, saturation: 1.0, brightness: 1.0)
        return color
    }
    
    
    var body: some View {
        NavigationSplitView(sidebar: {
            List(viewModel.update.aircraft, id: \.addr, selection: $selected) { aircraft in
                NavigationLink {
                    FlightDetailView(aircraft: aircraft)
                } label: {
                    HStack {
                        Image(systemName: "airplane")
                        Text(verbatim: aircraft.flight.count > 0 ? aircraft.flight : "(no flight number)")
                    }
                    
                }
            }
        }, content: {
            Text("Select a flight for details.").font(.footnote)
        }, detail: {
            Map(coordinateRegion: $visibleRegion,
                interactionModes: [.all], showsUserLocation: false, userTrackingMode: nil, annotationItems: viewModel.aircraftMarkers) { aircraft in
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
                    }
                    
                }
            }
        })
    }
}

struct AircraftAnnotation: View, MapAnnotationProtocol {
    var _annotationData: _MapAnnotationData
    
    var body: some View {
        Text("Hi")
    }
}

struct ContentView_Previews: PreviewProvider {
    static let testData: Data = {
        let url = Bundle.main.url(forResource: "aircraft-no-distance", withExtension: "pb")!
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            fatalError("couldn't get demo data: \(error.localizedDescription)")
        }
    }()
    
    static let aircraftsUpdate: AircraftsUpdate = {
        do {
            let meta = try AircraftsUpdate(serializedData: testData)
            return meta
        } catch {
            fatalError("couldn't materialize aircraft meta?")
        }
        
    }()
    
    static var previews: some View {
        Group {
            FlightListView(viewModel: FlightListViewModel(update: aircraftsUpdate)).frame(width: 1024, height: 768).previewDevice("Mac")
            FlightListView(viewModel: FlightListViewModel(update: aircraftsUpdate)).previewDevice("iPhone 14")
        }
    }
}
