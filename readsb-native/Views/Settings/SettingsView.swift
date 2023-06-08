//
//  SettingsView.swift
//  readsb-native
//
//  Created by Kiel Oleson on 4/24/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            ConnectionSettings()
                .tabItem {
                    Label("Connection", systemImage: "network")
                }
        }.frame(width: 640.0, height: 480.0)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
