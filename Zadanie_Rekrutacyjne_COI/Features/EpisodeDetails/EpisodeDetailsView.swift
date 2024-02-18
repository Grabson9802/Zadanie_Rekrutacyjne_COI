//
//  EpisodeDetailsView.swift
//  Zadanie_Rekrutacyjne_COI
//
//  Created by Krystian Grabowy on 16/02/2024.
//

import SwiftUI
import ComposableArchitecture

struct EpisodeDetailsView: View {
    let store: StoreOf<EpisodeDetailsFeature>
    let episodeID: Int
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let episode = store.episode, !store.isLoading {
                    episodeInfo(episode)
                    charactersCountInfo(episode)
                } else if store.isLoading {
                    ProgressView()
                } else {
                    Text(store.error ?? "Unknown error")
                }
            }
            .padding()
        }
        .onAppear {
            store.send(.onAppear(episodeID))
        }
        .navigationTitle("Episode Details")
    }
    
    private func episodeInfo(_ episode: Episode) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(episode.name)
                .font(.title)
            Text("Air date: \(episode.air_date)")
                .font(.subheadline)
            Text("Episode: \(episode.episode)")
                .font(.subheadline)
            Divider()
        }
    }
    
    private func charactersCountInfo(_ episode: Episode) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Number of characters appearing in this episode:")
                .font(.headline)
            Text("\(episode.characters.count)")
                .font(.title)
                .foregroundColor(.blue)
        }
    }
}
