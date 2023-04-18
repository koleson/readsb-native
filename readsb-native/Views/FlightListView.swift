//
//  FlightListView.swift
//  readsb-native
//
//  Created by Kiel Oleson on 4/17/23.
//

import SwiftUI

struct FlightListView: View {
    var viewModel: FlightListViewModel
    
    @State var searchText: String = "" {
        didSet {
            print("searchText is now \(searchText)")
        }
    }
    
    var searchResults: [AircraftMeta] {
        if searchText.isEmpty {
            print("searchText is empty - showing all aircraft")
            return viewModel.update.aircraft
        } else {
            print("filtering on searchtext \(searchText)")
            return viewModel.update.aircraft.filter { aircraft in
                aircraft.flight.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    @State var selected: Set<AircraftMeta> = []
    
    var body: some View {
        List {
            ForEach(searchResults, id: \.addr) { aircraftMeta in
                NavigationLink {
                                FlightDetailView(aircraft: aircraftMeta)
                } label: {
                    HStack {
                        Image(systemName: "airplane")
                        Text(verbatim: aircraftMeta.flight.isEmpty ? "(no flight number)" : aircraftMeta.flight)
                    }
                }
            }
        }.searchable(text: $searchText, placement: .sidebar)
    }
}

struct FlightListView_Previews: PreviewProvider {
    static var previews: some View {
        FlightListView(viewModel: FlightListViewModel(update: GlobalPreviewData.aircraftsUpdate))
    }
}
