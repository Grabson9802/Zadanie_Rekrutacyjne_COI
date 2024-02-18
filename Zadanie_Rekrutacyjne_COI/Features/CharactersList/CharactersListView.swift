//
//  ContentView.swift
//  Zadanie_Rekrutacyjne_COI
//
//  Created by Krystian Grabowy on 16/02/2024.
//

import SwiftUI
import ComposableArchitecture

struct CharactersListView: View {
    @EnvironmentObject var favoritesService: FavoritesService
    let store: StoreOf<CharactersListFeature>
    
    var body: some View {
        NavigationView {
            VStack {
                if store.error != nil {
                    errorMessage.padding()
                } else if store.showWelcomeMessage {
                    welcomeMessage.padding()
                    loadCharactersButton.padding()
                } else if store.isLoading {
                    ProgressView()
                } else {
                    sortingMenu
                    charactersList
                    pageNavigation.padding()
                }
            }
            .navigationTitle("Rick and Morty Characters")
            .toolbar { resetButton }
            .padding(.horizontal)
        }
    }
    
    private var welcomeMessage: some View {
        Text("Tap 'Load Characters' to discover the Rick and Morty universe.")
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    private var errorMessage: some View {
        VStack {
            Text(store.error ?? "Unknown error")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Retry") {
                store.send(.retryButtonTapped)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }
    
    private var charactersList: some View {
        List(store.characters) { character in
            NavigationLink(destination: CharacterDetailsView(character: character)) {
                characterRow(for: character)
            }
        }
        .listStyle(.plain)
    }
    
    private var filteredCharactersList: some View {
        List(store.characters.filter { favoritesService.isFavorite(id: $0.id) }) { character in
            NavigationLink(destination: CharacterDetailsView(character: character)) {
                characterRow(for: character)
            }
        }
        .listStyle(.plain)
    }
    
    private func characterRow(for character: Character) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(character.name)
                    .font(.headline)
                Text("Origin: \(character.origin.name)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if favoritesService.isFavorite(id: character.id) {
                Image(systemName: "star.fill")
                    .foregroundStyle(Color.yellow)
                    .accessibilityLabel("Favorite")
            }
        }
        .padding(.vertical, 4)
    }
    
    private var pageNavigation: some View {
        HStack {
            Button {
                store.send(.previousPageButtonTapped)
            } label: {
                Image(systemName: "arrow.left")
            }
            
            Spacer()
            
            Text("Page \(store.currentPage)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button {
                store.send(.nextPageButtonTapped)
            } label: {
                Image(systemName: "arrow.right")
            }
        }
        .padding(.top)
    }
    
    private var loadCharactersButton: some View {
        Button("Load Characters") {
            store.send(.loadCharactersButtonTapped)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }
    
    private var resetButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                store.send(.resetButtonTapped)
                favoritesService.clearFavorites()
            }) {
                Image(systemName: "arrow.counterclockwise")
            }
        }
    }
    
    private var sortingMenu: some View {
        HStack {
            Menu("Sort by - \(store.currentSortByValue.stringValue)") {
                ForEach(SortBy.allCases, id: \.self) { sortBy in
                    Button(sortBy.stringValue) {
                        store.send(.sortButtonTapped(sortBy: sortBy))
                    }
                }
            }
            .menuStyle(DefaultMenuStyle())
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    CharactersListView(store: Store(initialState: CharactersListFeature.State()) {
        CharactersListFeature()
    })
    .environmentObject(FavoritesService())
}
