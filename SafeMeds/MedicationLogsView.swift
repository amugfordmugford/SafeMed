import SwiftUI
import CoreData

struct MedicationLogsView: View {
    @ObservedObject var viewModel: MedicationLogViewModel
    var medication: Medication
    @State private var showDeleteAllLogsAlert = false

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.doseLogs(for: medication)) { log in
                    Text(log.timestampFormatted)
                }
                .onDelete { indexSet in
                    viewModel.deleteLog(at: indexSet, for: medication)
                }
            }

            Button("Delete All Logs") {
                showDeleteAllLogsAlert = true
            }
            .alert(isPresented: $showDeleteAllLogsAlert) {
                Alert(
                    title: Text("Delete all logs?"),
                    message: Text("This will permanently remove all dose logs."),
                    primaryButton: .destructive(Text("Delete")) {
                        viewModel.deleteAllDoseLogs(for: medication)
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .navigationTitle("Dose Logs")
    }
}
