//
//  RootViewModel.swift
//  readsb-native
//
//  Created by Kiel Oleson on 4/24/23.
//

import Foundation
import OSLog

class RootViewModel: ObservableObject {
    let logger = Logger(subsystem: "RootViewModel", category: "model")
    internal init(update: AircraftsUpdate?) {
        self.update = update
    }

    @Published var update: AircraftsUpdate?

    func getLatest() async {
        logger.info("getting latest update")
        let url = URL(string: "http://adsb-2.tworock.lan:8080/data/aircraft.pb")!
        let request = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                logger.error("got back unexpected response!")
                return
            }
            let newUpdate = try AircraftsUpdate(serializedData: data)
            DispatchQueue.main.sync {
                logger.info("setting update for RootViewModel")
                update = newUpdate
                logger.info("done setting update for RootViewModel")
            }
        } catch {
            logger.error("error getting latest: \(error.localizedDescription)")
        }
    }
}
