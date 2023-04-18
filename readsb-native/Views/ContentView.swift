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

class RootViewModel {
    internal init(update: AircraftsUpdate) {
        self.update = update
        aircraftMarkers = update.aircraft.map { aircraft in
            return AircraftPosition(flight: aircraft, coordinate: CLLocationCoordinate2D(latitude: aircraft.lat, longitude: aircraft.lon))
        }
    }
    
    var update: AircraftsUpdate
    
    var aircraftMarkers: [AircraftPosition]
}

struct ContentView: View {
    @State var selected: Set<AircraftMeta> = []
    
    var viewModel: RootViewModel
    
    var body: some View {
        NavigationSplitView(sidebar: {
            FlightListView(viewModel: FlightListViewModel(update: viewModel.update))
        }, content: {
            Text("Select a flight for details.").font(.footnote)
        }, detail: {
            // TODO:  extract.
            FlightMapView(aircraftMarkers: viewModel.aircraftMarkers)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(viewModel: RootViewModel(update: GlobalPreviewData.aircraftsUpdate)).frame(width: 1024, height: 768).previewDevice("Mac")
            ContentView(viewModel: RootViewModel(update: GlobalPreviewData.aircraftsUpdate)).previewDevice("iPhone 14")
        }
    }
}

struct GlobalPreviewData {
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
}
