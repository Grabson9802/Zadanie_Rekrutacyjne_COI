//
//  Zadanie_Rekrutacyjne_COIApp.swift
//  Zadanie_Rekrutacyjne_COI
//
//  Created by Krystian Grabowy on 16/02/2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct Zadanie_Rekrutacyjne_COIApp: App {
    private let store = Store(initialState: CharactersListFeature.State()) {
        CharactersListFeature()
    }
    private let favoritesService = FavoritesService()
    
    var body: some Scene {
        WindowGroup {
            CharactersListView(store: store)
                .environmentObject(favoritesService)
        }
    }
}
