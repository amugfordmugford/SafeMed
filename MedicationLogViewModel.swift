
import Foundation
import CoreData

class MedicationLogViewModel: ObservableObject {
    @Published var medications: [Medication] = []
    @Published var doseLogs: [DoseLog] = []
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        fetchMedications()
    }

    func fetchMedications() {
        let request: NSFetchRequest<Medication> = Medication.fetchRequest()
        do {
            medications = try context.fetch(request)
        } catch {
            print("Error fetching medications: \(error)")
        }
    }

    func fetchLogs(for medication: Medication) {
        let request: NSFetchRequest<DoseLog> = DoseLog.fetchRequest()
        request.predicate = NSPredicate(format: "medication == %@", medication)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DoseLog.timestamp, ascending: false)]
        do {
            doseLogs = try context.fetch(request)
        } catch {
            print("Error fetching dose logs: \(error)")
        }
    }

    func logDose(for medication: Medication, amount: Double) {
        let log = DoseLog(context: context)
        log.timestamp = Date()
        log.doseTaken = amount
        log.medication = medication
        log.uuid = UUID()

        saveContext()
        fetchLogs(for: medication)
    }

    func deleteLog(at offsets: IndexSet) {
        for offset in offsets {
            let log = doseLogs[offset]
            context.delete(log)
        }
        saveContext()
        if let med = doseLogs.first?.medication {
            fetchLogs(for: med)
        }
    }

    func deleteAllDoseLogs() {
        for log in doseLogs {
            context.delete(log)
        }
        saveContext()
        doseLogs.removeAll()
    }

    func deleteMedication(at offsets: IndexSet) {
        for offset in offsets {
            let med = medications[offset]
            context.delete(med)
        }
        saveContext()
        fetchMedications()
    }

    func deleteAllMedications() {
        for med in medications {
            context.delete(med)
        }
        saveContext()
        medications.removeAll()
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
