import Foundation
import CoreData

class MedicationLogViewModel: ObservableObject {
    let context: NSManagedObjectContext

    @Published var medications: [Medication] = []

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchMedications()
    }

    // MARK: - Medication CRUD

    func fetchMedications() {
        let request: NSFetchRequest<Medication> = Medication.fetchRequest()
        do {
            medications = try context.fetch(request)
        } catch {
            print("Failed to fetch medications: \(error)")
        }
    }

    func deleteMedication(at offsets: IndexSet) {
        for index in offsets {
            let medication = medications[index]
            context.delete(medication)
        }
        saveContext()
        fetchMedications()
    }

    func deleteAllMedications() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Medication.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            fetchMedications()
        } catch {
            print("Failed to delete all medications: \(error)")
        }
    }

    // MARK: - Dose Logs

    func doseLogs(for medication: Medication) -> [DoseLog] {
        let request: NSFetchRequest<DoseLog> = DoseLog.fetchRequest()
        request.predicate = NSPredicate(format: "medication == %@", medication)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DoseLog.timestamp, ascending: false)]

        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch dose logs: \(error)")
            return []
        }
    }

    func logDose(for medication: Medication, amount: Double) {
        let log = DoseLog(context: context)
        log.timestamp = Date()
        log.doseTaken = amount
        log.medication = medication
        log.uuid = UUID()

        saveContext()
    }

    func deleteLog(at offsets: IndexSet, for medication: Medication) {
        let logs = doseLogs(for: medication)
        for index in offsets {
            context.delete(logs[index])
        }
        saveContext()
    }

    func deleteAllDoseLogs(for medication: Medication) {
        let request: NSFetchRequest<DoseLog> = DoseLog.fetchRequest()
        request.predicate = NSPredicate(format: "medication == %@", medication)
        do {
            let logs = try context.fetch(request)
            for log in logs {
                context.delete(log)
            }
            saveContext()
        } catch {
            print("Failed to delete all logs: \(error)")
        }
    }

    // MARK: - Save

    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
