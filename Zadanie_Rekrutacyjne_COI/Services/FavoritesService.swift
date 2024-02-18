//
//  FavoritesService.swift
//  Zadanie_Rekrutacyjne_COI
//
//  Created by Krystian Grabowy on 17/02/2024.
//

import Foundation

class FavoritesService: ObservableObject {
    @Published var favorites: Set<Int> {
        didSet {
            saveFavorites()
        }
    }
    
    private let favoritesKey = "Favorites"
    
    init() {
        self.favorites = []
        self.favorites = Set(loadFavorites())
    }
    
    func toggleFavorite(id: Int) {
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
    }
    
    func isFavorite(id: Int) -> Bool {
        return favorites.contains(id)
    }
    
    private func loadFavorites() -> [Int] {
        return UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
    }
    
    private func saveFavorites() {
        UserDefaults.standard.set(Array(favorites), forKey: favoritesKey)
    }
    
    func clearFavorites() {
        favorites.removeAll()
    }
}
