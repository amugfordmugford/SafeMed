import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: MedicationLogViewModel

    @State private var showDeleteAllAlert = false
    @State private var showAddMedication = false
    @State private var selectedMedicationForLogs: Medication?
    @State private var selectedMedicationForDose: Medication?

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: MedicationLogViewModel(context: context))
    }

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.medications) { medication in
                        VStack(alignment: .leading) {
                            Text(medication.name ?? "Unnamed Medication")
                                .font(.headline)

                            HStack {
                                Button("View Logs") {
                                    selectedMedicationForLogs = medication
                                }

                                Spacer()

                                Button("Log Dose") {
                                    selectedMedicationForDose = medication
                                }
                            }
                            .font(.subheadline)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: viewModel.deleteMedication)
                }

                HStack {
                    Button("Delete All Medications") {
                        showDeleteAllAlert = true
                    }
                    .alert(isPresented: $showDeleteAllAlert) {
                        Alert(
                            title: Text("Are you sure?"),
                            message: Text("This will delete all medications and cannot be undone."),
                            primaryButton: .destructive(Text("Delete")) {
                                viewModel.deleteAllMedications()
                            },
                            secondaryButton: .cancel()
                        )
                    }

                    Spacer()

                    Button("Add Medication") {
                        showAddMedication = true
                    }
                    .sheet(isPresented: $showAddMedication) {
                        AddMedicationView(viewModel: viewModel)
                            .environment(\.managedObjectContext, viewContext)
                    }
                }
                .padding()
            }
            .navigationTitle("Medications")
            .navigationDestination(isPresented: Binding(
                get: { selectedMedicationForLogs != nil },
                set: { if !$0 { selectedMedicationForLogs = nil } }
            )) {
                if let medication = selectedMedicationForLogs {
                    MedicationLogsView(viewModel: viewModel, medication: medication)
                }
            }
            .navigationDestination(isPresented: Binding(
                get: { selectedMedicationForDose != nil },
                set: { if !$0 { selectedMedicationForDose = nil } }
            )) {
                if let medication = selectedMedicationForDose {
                    LogDoseView(viewModel: viewModel, medication: medication)
                }
            }
        }
    }
}
