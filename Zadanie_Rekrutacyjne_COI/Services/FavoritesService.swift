//
//  FavoritesService.swift
//  Zadanie_Rekrutacyjne_COI
//
//  Created by Krystian Grabowy on 17/02/2024.
//

import Foundation
import ComposableArchitecture

class FavoritesService: ObservableObject {
    @Published var favorites: [Character] {
        didSet {
            saveFavorites()
        }
    }

    private let favoritesKey = "Favorites"

    init() {
        self.favorites = []
        self.favorites = loadFavorites()
    }

    func toggleFavorite(character: Character) {
        if let index = favorites.firstIndex(where: { $0.id == character.id }) {
            favorites.remove(at: index)
        } else {
            favorites.append(character)
        }
    }

    func isFavorite(id: Int) -> Bool {
        return favorites.contains(where: { $0.id == id })
    }

    func clearFavorites() {
        favorites.removeAll()
    }

    private func loadFavorites() -> [Character] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey) else { return [] }
        return (try? JSONDecoder().decode([Character].self, from: data)) ?? []
    }

    private func saveFavorites() {
        let data = try? JSONEncoder().encode(favorites)
        UserDefaults.standard.set(data, forKey: favoritesKey)
    }
}


extension DependencyValues {
    var favoritesService: FavoritesService {
        get { self[FavoritesServiceKey.self] }
        set { self[FavoritesServiceKey.self] = newValue }
    }

    private struct FavoritesServiceKey: DependencyKey {
        static let liveValue = FavoritesService()
    }
}
