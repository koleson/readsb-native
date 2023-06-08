//
//  FlightListView.swift
//  readsb-native
//
//  Created by Kiel Oleson on 4/17/23.
//

import SwiftUI
import MapKit
import OSLog

class FlightListViewModel {
    internal init(aircraft: [AircraftMeta]) {
        self.aircraft = aircraft
    }

    var aircraft: [AircraftMeta]
}

struct FlightListView: View {
    let logger = Logger(subsystem: "FlightListView", category: "interaction")
    let filterLogger = Logger(subsystem: "FlightListView", category: "model")
    var viewModel: FlightListViewModel

    @State var searchText: String = "" {
        didSet {
            logger.info("searchText is now \(searchText)")
        }
    }

    // TODO:  move to view model
    var searchResults: [AircraftMeta] {
        if searchText.isEmpty {
            filterLogger.info("searchText is empty - showing all aircraft")
            return viewModel.aircraft
        } else {
            filterLogger.info("filtering on searchtext \(searchText, privacy: .public)")
            return viewModel.aircraft.filter { aircraft in
                aircraft.flight.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    @State var selected: Set<AircraftMeta> = []

    var body: some View {
        List {
            ForEach(searchResults, id: \.addr) { aircraft in
                NavigationLink {
                    FlightDetailView(aircraft: aircraft)
                } label: {
                    HStack {
                        Image(systemName: "airplane")
                        Text(verbatim: aircraft.flight.isEmpty ? "(no flight number)" : aircraft.flight)
                    }
                }
            }
        }.searchable(text: $searchText, placement: .sidebar)
    }
}

struct FlightListView_Previews: PreviewProvider {
    static var previews: some View {
        FlightListView(viewModel: FlightListViewModel(aircraft: GlobalPreviewData.aircraftsUpdate.aircraft))
    }
}
