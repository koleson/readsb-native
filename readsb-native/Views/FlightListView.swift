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
    
    @State var selected: Set<AircraftMeta> = []
    
    var body: some View {
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
        .searchable(text: $searchText)
    }
}

struct FlightListView_Previews: PreviewProvider {
    static var previews: some View {
        FlightListView(viewModel: FlightListViewModel(update: GlobalPreviewData.aircraftsUpdate))
    }
}
