//
//  FlightListView.swift
//  readsb-native
//
//  Created by Kiel Oleson on 4/17/23.
//

import SwiftUI
import MapKit

class FlightListViewModel {
    internal init(aircraft: [AircraftMeta]) {
        self.aircraft = aircraft
    }

    var aircraft: [AircraftMeta]
}

struct FlightListView: View {
    var viewModel: FlightListViewModel

    @State var searchText: String = "" {
        didSet {
            print("searchText is now \(searchText)")
        }
    }

    var searchResults: [AircraftMeta] {
        if searchText.isEmpty {
            // print("searchText is empty - showing all aircraft")
            return viewModel.aircraft
        } else {
            // print("filtering on searchtext \(searchText)")
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
