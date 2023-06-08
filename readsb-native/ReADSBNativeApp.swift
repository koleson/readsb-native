//
//  readsb_nativeApp.swift
//  readsb-native
//
//  Created by Kiel Oleson on 4/14/23.
//

import SwiftUI

@main
struct ReADSBNativeApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: RootViewModel(update: GlobalPreviewData.aircraftsUpdate))
        }
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }

    private func getUpdate() {

    }
}
