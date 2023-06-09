//
//  Airframe+CoreDataProperties.swift
//  readsb-native
//
//  Created by Kiel Oleson on 6/8/23.
//
//

import Foundation
import CoreData

extension Airframe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Airframe> {
        return NSFetchRequest<Airframe>(entityName: "Airframe")
    }

    @NSManaged public var address: Int32
    @NSManaged public var airlineCallsign: String?
    @NSManaged public var airlineIATA: String?
    @NSManaged public var airlineICAO: String?
    @NSManaged public var icaoDescription: String?
    @NSManaged public var icaoManufacturer: String?
    @NSManaged public var icaoType: String?
    @NSManaged public var lineNumber: String?
    @NSManaged public var manufacturer: String?
    @NSManaged public var model: String?
    @NSManaged public var owner: String?
    @NSManaged public var registration: String?
    @NSManaged public var serialNumber: String?

}

extension Airframe: Identifiable {

}
