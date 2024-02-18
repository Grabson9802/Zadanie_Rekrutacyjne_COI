//
//  CharacterDetailsFeature.swift
//  Zadanie_Rekrutacyjne_COI
//
//  Created by Krystian Grabowy on 18/02/2024.
//

import ComposableArchitecture

@Reducer
struct CharacterDetailsFeature {
    @ObservableState
    struct State {
        var isFavorite: Bool = false
    }
    
    enum Action {
        case toggleFavorite(Character)
        case onAppear(Int)
    }
    
    @Dependency(\.favoritesService) var favoritesService
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .toggleFavorite(let character):
                state.isFavorite.toggle()
                favoritesService.toggleFavorite(character: character)
                return .none
            case .onAppear(let characterID):
                state.isFavorite = favoritesService.isFavorite(id: characterID)
                return .none
            }
        }
    }
}
