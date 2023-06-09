//
//  AirframeDataStore.swift
//  readsb-native
//
//  Created by Kiel Oleson on 6/9/23.
//

import Foundation
import CoreData
import OSLog

class AirframeDataStore {
    enum State {
        case idle
        case importing
        case ready
    }

    var state: State = .idle

    static let shared = AirframeDataStore()

    private let resetPersistentStoreEveryLaunch = true

    private let persistentContainerLogger = Logger(subsystem: "CoreData", category: "PersistentContainer")

    private lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Airframes")
            container.loadPersistentStores { [weak self] description, error in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                } else {
                    self?.persistentContainerLogger.info(
                        "set up persistent container successfully - \(description)")
                }
            }
            return container
        }()

    func prepare() {
        if resetPersistentStoreEveryLaunch {
            resetPersistentStore(forContainer: persistentContainer)
        }
    }

    private func resetPersistentStore(forContainer persistentContainerToReset: NSPersistentContainer) {
        // based on https://stackoverflow.com/questions/53946485/core-data-how-to-reset-everything-when-setup-with-loadpersistentstores
        if let currentStore = persistentContainer.persistentStoreCoordinator.persistentStores.last,
           let storeURL = currentStore.url {
            do {
                try persistentContainerToReset.persistentStoreCoordinator
                    .destroyPersistentStore(at: storeURL, type: .sqlite)
                try _ = persistentContainerToReset.persistentStoreCoordinator
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

    private func importInBackground() {
        let importContext = persistentContainer.newBackgroundContext()

        let testFetchRequest = Airframe.fetchRequest()
        let context = persistentContainer.viewContext
        do {
            let preImportObjects = try context.fetch(testFetchRequest)
            persistentContainerLogger.notice("pre-import Airframes count: \(preImportObjects.count)")
        } catch {
            persistentContainerLogger.error("couldn't get pre-import Airframes state: \(error.localizedDescription)")
        }

        let aircraftDBURL = Bundle.main.url(forResource: "aircraft-database-complete-2023-06",
                                            withExtension: "csv")!

        let importStartTime = CFAbsoluteTimeGetCurrent()
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.persistentContainerLogger.notice("starting aircraft import")
            let importer = TabularDataAirframeCSVImporter()
            importer.importAirframes(fromCSVatURL: aircraftDBURL, intoContext: importContext)
            let importEndTime = CFAbsoluteTimeGetCurrent()
            let importElapsedTime = importEndTime - importStartTime
            self?.persistentContainerLogger.notice("imported airframes DB in \(importElapsedTime) seconds")

            DispatchQueue.main.async {
                do {
                    let postImportObjects = try context.fetch(testFetchRequest)
                    self?.persistentContainerLogger.notice("Airframes count: \(postImportObjects.count)")
                } catch {
                    self?.persistentContainerLogger.error("couldn't get post-import objects to get airframes count")
                }
            }
        }
    }

    func airframe(icaoAddress: Int) -> Airframe? {
        return nil
    }
}
