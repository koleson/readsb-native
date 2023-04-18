//
//  FlightDetailView.swift
//  readsb-native
//
//  Created by Kiel Oleson on 4/17/23.
//

import SwiftUI

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
