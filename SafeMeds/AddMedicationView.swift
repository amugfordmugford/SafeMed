import SwiftUI
import Foundation
import CoreData

struct AddMedicationView: View {
    @ObservedObject var viewModel: MedicationLogViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var dose: Double = 0.0
    @State private var frequency: String = ""
    @State private var maxDose: Double = 0.0

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Medication Info")) {
                    TextField("Name", text: $name)
                    TextField("Dose", value: $dose, format: .number)
                        .keyboardType(.decimalPad)
                    TextField("Frequency", text: $frequency)
                    TextField("Max Dose", value: $maxDose, format: .number)
                        .keyboardType(.decimalPad)
                }

                Button("Save") {
                    let medication = Medication(context: viewModel.context)
                    medication.name = name
                    medication.dose = dose
                    medication.frequency = frequency
                    medication.maxDose = maxDose

                    viewModel.saveContext()
                    viewModel.fetchMedications()
                    dismiss()
                }
                .disabled(name.isEmpty)
            }
            .navigationTitle("Add Medication")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
