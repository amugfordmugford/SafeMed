//
//  Medication+CoreDataProperties.swift
//  SafeMeds
//
//  Created by Andrew Mugford on 2025-07-12.
//
//

import Foundation
import CoreData


extension Medication {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medication> {
        return NSFetchRequest<Medication>(entityName: "Medication")
    }

    @NSManaged public var dose: Double
    @NSManaged public var frequency: String?
    @NSManaged public var frequencyHours: Double
    @NSManaged public var maxDailyDose: Double
    @NSManaged public var maxDose: Double
    @NSManaged public var name: String?
    @NSManaged public var doseLogs: NSSet?

}

// MARK: Generated accessors for doseLogs
extension Medication {

    @objc(addDoseLogsObject:)
    @NSManaged public func addToDoseLogs(_ value: DoseLog)

    @objc(removeDoseLogsObject:)
    @NSManaged public func removeFromDoseLogs(_ value: DoseLog)

    @objc(addDoseLogs:)
    @NSManaged public func addToDoseLogs(_ values: NSSet)

    @objc(removeDoseLogs:)
    @NSManaged public func removeFromDoseLogs(_ values: NSSet)

}

extension Medication : Identifiable {

}
