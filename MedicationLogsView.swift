
import SwiftUI

struct MedicationLogsView: View {
    @ObservedObject var viewModel: MedicationLogViewModel
    var medication: Medication
    @State private var showDeleteAllLogsAlert = false

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.doseLogs) { log in
                    Text(log.timestampFormatted)
                }
                .onDelete(perform: viewModel.deleteLog)
            }

            Button("Delete All Logs") {
                showDeleteAllLogsAlert = true
            }
            .alert(isPresented: $showDeleteAllLogsAlert) {
                Alert(
                    title: Text("Delete all logs?"),
                    message: Text("This will permanently remove all dose logs."),
                    primaryButton: .destructive(Text("Delete")) {
                        viewModel.deleteAllDoseLogs()
                    },
                    secondaryButton: .cancel()
                )
            }

            NavigationLink(destination: LogDoseView(viewModel: viewModel, medication: medication)) {
                Text("Log a Dose")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Dose Logs")
        .onAppear {
            viewModel.fetchLogs(for: medication)
        }
    }
}
