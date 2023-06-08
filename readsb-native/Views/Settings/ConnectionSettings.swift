//
//  ConnectionSettings.swift
//  readsb-native
//
//  Created by Kiel Oleson on 4/24/23.
//

import SwiftUI

struct ConnectionSettings: View {

    @State var serverAddress: String = ""
    @State var update: Bool = false
    @State var updateInterval: Double = 0.5

    var body: some View {
        VStack {
            Text("Connection Settings (IN PROGRESS)").font(.title)
            Form {
                Toggle("Update", isOn: $update)
                Slider(value: $updateInterval, in: 0.1...2.0, step: 0.1) {
                    Text("Update Interval: \(updateInterval, specifier: "%.1f") seconds")
                }
                TextField(text: $serverAddress, prompt: Text("http://example.com:8078/")) {
                    Text("Server Address")
                }
            }.padding(20.0)
        }
    }
}

struct ConnectionSettings_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionSettings()
    }
}
