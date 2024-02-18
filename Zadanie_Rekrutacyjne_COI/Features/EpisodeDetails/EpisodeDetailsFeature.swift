//
//  EpisodeDetailsFeature.swift
//  Zadanie_Rekrutacyjne_COI
//
//  Created by Krystian Grabowy on 16/02/2024.
//

import ComposableArchitecture

@Reducer
struct EpisodeDetailsFeature {
    @ObservableState
    struct State {
        var episode: Episode?
        var isLoading = false
        var error: String?
    }
    
    enum Action {
        case onAppear(Int)
        case episodeResponse(Result<Episode, APIError>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear(let selectedEpisodeID):
                state.isLoading = true
                return .run { send in
                    let result = await APIClient().getEpisode(byId: selectedEpisodeID)
                    await send(.episodeResponse(result))
                }
                
            case .episodeResponse(.success(let episode)):
                state.episode = episode
                state.isLoading = false
                return .none
                
            case .episodeResponse(.failure(let apiError)):
                state.error = apiError.localizedDescription
                state.isLoading = false
                return .none
            }
        }
    }
}
