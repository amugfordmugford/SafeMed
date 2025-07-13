//
//  Route.swift
//  SafeMeds
//
//  Created by Andrew Mugford on 2025-07-12.
//
enum Route: Hashable {
    case logDose(Medication)
    case viewHistory(Medication)
    case addMedication
}
