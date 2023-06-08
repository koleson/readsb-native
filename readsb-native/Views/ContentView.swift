//
//  ContentView.swift
//  readsb-native
//
//  Created by Kiel Oleson on 4/14/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State var selected: Set<AircraftMeta> = []

    @StateObject var viewModel: RootViewModel

    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-a-timer-with-swiftui
    let updateTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationSplitView(sidebar: {
            FlightListView(viewModel: FlightListViewModel(aircraft: viewModel.update?.aircraft ?? []))
        }, content: {
            Text("Select a flight for details.").font(.footnote)
        }, detail: {
            FlightMapView(aircraft: viewModel.update?.aircraft ?? [])
        })
        .onReceive(updateTimer) { _ in
            Task {
                await viewModel.getLatest()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(viewModel: RootViewModel(update: GlobalPreviewData.aircraftsUpdate))
                .frame(width: 1024, height: 768)
                .previewDevice("Mac")
            ContentView(viewModel: RootViewModel(update: GlobalPreviewData.aircraftsUpdate))
                .previewDevice("iPhone 14")
        }
    }
}
