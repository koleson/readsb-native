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
    let resetPersistentStoreEveryLaunch = true

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: RootViewModel(update: GlobalPreviewData.aircraftsUpdate)).onAppear {
                Task {

                    // TODO:  extract all this into its own class that also tracks its own state
                    // if we try to read from airframes while it's loading, we won't get data we would get
                    // if we waited just a moment.
                    
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

                    if resetPersistentStoreEveryLaunch {
                        // based on https://stackoverflow.com/questions/53946485/core-data-how-to-reset-everything-when-setup-with-loadpersistentstores
                        if let currentStore = persistentContainer.persistentStoreCoordinator.persistentStores.last,
                           let storeURL = currentStore.url {
                            do {
                                try persistentContainer.persistentStoreCoordinator
                                    .destroyPersistentStore(at: storeURL, type: .sqlite)
                                try _ = persistentContainer.persistentStoreCoordinator
                                    .addPersistentStore(type: .sqlite, at: storeURL)
                            } catch {
                                persistentContainerLogger.error(
                                    "error resetting persistent store: \(error.localizedDescription)")
                            }
                            persistentContainerLogger.notice("reset persistent store successfully!")
                        } else {
                            persistentContainerLogger.error("could not get current store URL to reset the store")
                        }
                    }

                    let importContext = persistentContainer.newBackgroundContext()

                    let testFetchRequest = Airframe.fetchRequest()
                    let context = persistentContainer.viewContext
                    let preImportObjects = try context.fetch(testFetchRequest)
                    persistentContainerLogger.notice("pre-import Airframes count: \(preImportObjects.count)")

                    let aircraftDBURL = Bundle.main.url(forResource: "aircraft-database-complete-2023-06",
                                                        withExtension: "csv")!

                    let importStartTime = CFAbsoluteTimeGetCurrent()
                    DispatchQueue.global(qos: .background).async {
                        persistentContainerLogger.notice("starting aircraft import")
                        let importer = TabularDataAirframeCSVImporter()
                        importer.importAirframes(fromCSVatURL: aircraftDBURL, intoContext: importContext)
                        let importEndTime = CFAbsoluteTimeGetCurrent()
                        let importElapsedTime = importEndTime - importStartTime
                        persistentContainerLogger.notice("imported airframes DB in \(importElapsedTime) seconds")

                        DispatchQueue.main.async {
                            do {
                                let postImportObjects = try context.fetch(testFetchRequest)
                                persistentContainerLogger.notice("Airframes count: \(postImportObjects.count)")
                            } catch {
                                persistentContainerLogger.error("couldn't get post-import objects to get airframes count")
                            }
                        }
                    }
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
