//
//  LogDoseView.swift
//  SafeMeds
//
//  Created by Andrew Mugford on 2025-07-12.
//
import SwiftUI
import Foundation

struct LogDoseView: View {
    @ObservedObject var viewModel: MedicationLogViewModel
    var medication: Medication
    @Environment(\.dismiss) private var dismiss

    @State private var doseTaken: Double = 0.0

    var body: some View {
        Form {
            Section(header: Text("Log a Dose")) {
                Text("Medication: \(medication.name ?? "Unnamed")")
                TextField("Dose Taken", value: $doseTaken, format: .number)
                    .keyboardType(.decimalPad)
            }

            if doseTaken > medication.maxDose {
                Text("⚠️ This exceeds the recommended maximum dose.")
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button("Log Dose") {
                viewModel.logDose(for: medication, amount: doseTaken)
                dismiss()
            }
            .disabled(doseTaken <= 0)
        }
        .navigationTitle("Log Dose")
    }
}
