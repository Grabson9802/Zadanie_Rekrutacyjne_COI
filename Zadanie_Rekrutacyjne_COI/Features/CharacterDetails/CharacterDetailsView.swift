//
//  CharacterDetailsView.swift
//  Zadanie_Rekrutacyjne_COI
//
//  Created by Krystian Grabowy on 16/02/2024.
//

import SwiftUI
import ComposableArchitecture

struct CharacterDetailsView: View {
    @EnvironmentObject var favoritesService: FavoritesService
    
    let character: Character
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                characterInfo.padding()
                
                characterImage
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .padding()
                
                episodesList
            }
            .padding()
        }
        .navigationTitle("Character Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { favoriteButton }
    }
    
    private var characterInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Name: \(character.name)")
                .font(.headline)
            Text("Status: \(character.status)")
                .font(.subheadline)
            Text("Gender: \(character.gender)")
                .font(.subheadline)
            Text("Origin: \(character.origin.name)")
                .font(.subheadline)
            Text("Location: \(character.location.name)")
                .font(.subheadline)
        }
    }
    
    private var characterImage: some View {
        AsyncImage(url: URL(string: character.image)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .cornerRadius(16) // Zaokrąglenie krawędzi
                .shadow(radius: 5) // Cień
        } placeholder: {
            ProgressView()
        }
    }
    
    private var episodesList: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Episodes:")
                .font(.headline)
            ForEach(character.episodeIds, id: \.self) { episodeId in
                NavigationLink(destination: EpisodeDetailsView(store: Store(initialState: EpisodeDetailsFeature.State()) {
                    EpisodeDetailsFeature()
                }, episodeID: episodeId)) {
                    Text("Episode \(episodeId)")
                        .font(.subheadline)
                }
            }
        }
    }
    
    private var favoriteButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                favoritesService.toggleFavorite(id: character.id)
            }) {
                Image(systemName: favoritesService.isFavorite(id: character.id) ? "star.fill" : "star")
                    .font(.title2)
                    .foregroundStyle(favoritesService.isFavorite(id: character.id) ? .yellow : .gray)
            }
        }
    }
}
