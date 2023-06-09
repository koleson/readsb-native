//
//  readsb_nativeApp.swift
//  readsb-native
//
//  Created by Kiel Oleson on 4/14/23.
//

import SwiftUI
import OSLog

@main
struct ReADSBNativeApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: RootViewModel(update: GlobalPreviewData.aircraftsUpdate)).onAppear {
                Task {
                    AirframeDataStore.shared.prepare()
                }
            }
        }
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}
