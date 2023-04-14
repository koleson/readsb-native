//
//  ContentView.swift
//  readsb-native
//
//  Created by Kiel Oleson on 4/14/23.
//

import SwiftUI

struct ContentView: View {
//    var staticAircraft = Air
    var update: AircraftsUpdate
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Text("messages history: \(update.messages)")
            Text("aircraft: \(update.aircraft.count)")
            VStack {
                ForEach(update.aircraft, id: \.addr) { aircraft in
                    Text(verbatim: aircraft.flight.count > 0 ? aircraft.flight : "(no flight number)")
                }
            }
            Text("aircraft history: \(update.history.count)")
        }
        .padding()
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
        ContentView(update: aircraftsUpdate)
    }
}
