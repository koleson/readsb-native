//
//  TabularDataAirframeCSVImporter.swift
//  readsb-native
//
//  Created by Kiel Oleson on 6/8/23.
//

import Foundation
import OSLog
import CoreData
import TabularData

class TabularDataAirframeCSVImporter {
    private let icaoAddrColumn = ColumnID("ICAOAddr", String.self)      // will convert to int when storing in Core Data
    private let regColumn = ColumnID("Reg", String.self)
    private let icaoManufacturerColumn = ColumnID("ICAOManu", String.self)
    private let manufacturerColumn = ColumnID("Manu", String.self)
    private let modelColumn = ColumnID("Model", String.self)
    private let icaoTypeColumn = ColumnID("ICAOType", String.self)
    private let lineNumberColumn = ColumnID("LineNumber", String.self)  // "number" here can include symbols/letters
    private let serialNumberColumn = ColumnID("SerialNumber", String.self)  // "number" here can include symbols/letters
    // TODO:  make adsbtype an enum? or add enum-derivation column
    private let adsBTypeColumn = ColumnID("ADSBType", String.self)
    private let airlineColumn = ColumnID("Airline", String.self)
    private let airlineCallsignColumn = ColumnID("AirlineCallsign", String.self)
    private let airlineIATAColumn = ColumnID("AirlineIATA", String.self)
    private let airlineICAOColumn = ColumnID("AirlineICAO", String.self)
    private let ownerColumn = ColumnID("Owner", String.self)
    private let notesColumn = ColumnID("OtherNotes", String.self)

    static let logger = Logger(subsystem: "TabularDataAirframeCSVImporter", category: "import")

    func importAirframes(fromCSVatURL csvURL: URL, intoContext context: NSManagedObjectContext) {
        // stuff
        let options = CSVReadingOptions(
            hasHeaderRow: true,
            nilEncodings: [""],
            ignoresEmptyLines: true,
            delimiter: ","
        )

        do {
            let columnIDs = [ icaoAddrColumn, regColumn, icaoManufacturerColumn, manufacturerColumn, modelColumn,
                              icaoTypeColumn, lineNumberColumn, serialNumberColumn, adsBTypeColumn, airlineColumn,
                              airlineCallsignColumn, airlineIATAColumn, airlineICAOColumn, ownerColumn, notesColumn ]

            let columnNames = columnIDs.map { $0.name }
            var columnTypes: [String: CSVType] = [:]
            for column in columnNames {
                columnTypes[column] = .string       // all strings all day
            }

            let dataFrameStartTime = CFAbsoluteTimeGetCurrent()

            let dataFrame = try DataFrame(contentsOfCSVFile: csvURL,
                                          columns: columnNames,
//                                          rows: 0..<5,
//                                          rows: 0..<580000,
                                          types: columnTypes,
                                          options: options)

            let dataFrameEndTime = CFAbsoluteTimeGetCurrent()

            // dataframe ready - now can pull things from it to import to coredata!
            let coreDataImportStartTime = CFAbsoluteTimeGetCurrent()

            for row in dataFrame.rows {
                addAirframe(fromRow: row, inContext: context)
            }

            let coreDataImportEndTime = CFAbsoluteTimeGetCurrent()
            TabularDataAirframeCSVImporter.logger.notice("DataFrame creation took \(dataFrameEndTime - dataFrameStartTime) seconds")
            TabularDataAirframeCSVImporter.logger.notice("Core Data entity creation took \(coreDataImportEndTime - coreDataImportStartTime) seconds")
        } catch {
            TabularDataAirframeCSVImporter.logger.error(
                "couldn't import CSV to DataFrame: \(error.localizedDescription)")
        }

        do {
            try context.save()
        } catch {
            TabularDataAirframeCSVImporter.logger.error("couldn't save context: \(error.localizedDescription)")
        }

    }

    func addAirframe(fromRow row: DataFrame.Rows.Element, inContext context: NSManagedObjectContext) {
        guard let icaoAddrString = row[icaoAddrColumn], let icaoAddrInt = Int32(icaoAddrString, radix: 16) else {
            print("error getting icaoAddrString or int")
            return
        }

        let newAirframe = Airframe(context: context)
        newAirframe.address = icaoAddrInt
        // TODO:  add all the other attributes
    }
}
