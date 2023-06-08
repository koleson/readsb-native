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
                    let persistentContainerLogger = Logger(subsystem: "CoreData", category: "PersistentContainer")

                    lazy var persistentContainer: NSPersistentContainer = {
                            let container = NSPersistentContainer(name: "Airframes")
                            container.loadPersistentStores { description, error in
                                if let error = error {
                                    fatalError("Unable to load persistent stores: \(error)")
                                } else {
                                    persistentContainerLogger.info(
                                        "set up persistent container successfully - \(description)")
                                }
                            }
                            return container
                        }()
//                    let testAirframe = persistentContainer.m
                }
            }
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
