//
//  SortBy.swift
//  Zadanie_Rekrutacyjne_COI
//
//  Created by Krystian Grabowy on 18/02/2024.
//

enum SortBy: CaseIterable {
    case id, name, status, gender, origin, location
    
    var stringValue: String {
        switch self {
        case .id: return "ID"
        case .name: return "Name"
        case .status: return "Status"
        case .gender: return "Gender"
        case .origin: return "Origin"
        case .location: return "Location"
        }
    }
}
