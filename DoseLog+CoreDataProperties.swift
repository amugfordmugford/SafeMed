//
//  DoseLog+CoreDataProperties.swift
//  SafeMeds
//
//  Created by Andrew Mugford on 2025-07-12.
//
//

import Foundation
import CoreData

extension DoseLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DoseLog> {
        return NSFetchRequest<DoseLog>(entityName: "DoseLog")
    }

    @NSManaged public var doseTaken: Double
    @NSManaged public var timestamp: Date?
    @NSManaged public var uuid: UUID?
    @NSManaged public var medication: Medication?
}

extension DoseLog: Identifiable { }

extension DoseLog {
    var timestampFormatted: String {
        timestamp?.formatted(date: .abbreviated, time: .shortened) ?? "Unknown"
    }
}
