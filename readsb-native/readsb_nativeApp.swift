//
//  readsb_nativeApp.swift
//  readsb-native
//
//  Created by Kiel Oleson on 4/14/23.
//

import SwiftUI

@main
struct readsb_nativeApp: App {
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
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: RootViewModel(update: readsb_nativeApp.aircraftsUpdate))
        }
    }
}
