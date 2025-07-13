import SwiftUI
import Foundation

struct MedicationRow: View {
    let medication: Medication

    var body: some View {
        VStack(alignment: .leading) {
            Text(medication.name ?? "Unnamed Medication")
                .font(.headline)

            Text(String(format: "Dose: %.1f", medication.dose))
                .font(.subheadline)
                .foregroundColor(.secondary)

            if let frequency = medication.frequency {
                Text("Frequency: \(frequency)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            if medication.maxDose > 0 {
                Text(String(format: "Max Dose: %.1f", medication.maxDose))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
