//
//  Character.swift
//  Zadanie_Rekrutacyjne_COI
//
//  Created by Krystian Grabowy on 16/02/2024.
//

import Foundation

struct CharactersResponse: Codable {
    let info: Info
    let results: [Character]
}

struct Info: Codable {
    let next: String?
    let prev: String?
}

struct Character: Codable, Identifiable {
    let id: Int
    let name: String
    let status: String
    let gender: String
    let origin: Origin
    let location: Location
    let image: String
    let episode: [String]
    
    var episodeIds: [Int] {
        episode.compactMap { URL(string: $0)?.lastPathComponent }.compactMap { Int($0) }
    }
}

struct Origin: Codable {
    let name: String
}

struct Location: Codable {
    let name: String
}
