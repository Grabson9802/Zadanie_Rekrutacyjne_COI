//
//  Episode.swift
//  Zadanie_Rekrutacyjne_COI
//
//  Created by Krystian Grabowy on 16/02/2024.
//

struct Episode: Codable, Identifiable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
}
