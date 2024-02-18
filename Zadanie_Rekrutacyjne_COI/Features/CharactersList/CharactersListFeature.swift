//
//  CharactersListFeature.swift
//  Zadanie_Rekrutacyjne_COI
//
//  Created by Krystian Grabowy on 16/02/2024.
//

import ComposableArchitecture

@Reducer
struct CharactersListFeature {
    @ObservableState
    struct State {
        var info: Info = Info(next: nil, prev: nil)
        var characters: [Character] = []
        var isLoading = false
        var error: String? = nil
        var showWelcomeMessage = true
        var currentPage = 1
        var currentSortByValue: SortBy = .id
    }
    
    enum Action {
        case loadCharactersButtonTapped
        case charactersResponseReceived(Result<CharactersResponse, APIError>)
        case resetButtonTapped
        case nextPageButtonTapped
        case previousPageButtonTapped
        case retryButtonTapped
        case sortButtonTapped(sortBy: SortBy)
        case charactersSorted
    }
    
    @Dependency(\.apiClient) var apiClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .charactersSorted:
                switch state.currentSortByValue {
                case .status:
                    state.characters.sort(by: {$0.status < $1.status})
                case .gender:
                    state.characters.sort(by: {$0.gender < $1.gender})
                case .origin:
                    state.characters.sort(by: {$0.origin.name < $1.origin.name})
                case .location:
                    state.characters.sort(by: {$0.location.name < $1.location.name})
                case .id:
                    state.characters.sort(by: {$0.id < $1.id})
                case .name:
                    state.characters.sort(by: {$0.name < $1.name})
                }
                return .none
            case .sortButtonTapped(let sortBy):
                state.currentSortByValue = sortBy
                return .run { send in
                    await send(.charactersSorted)
                }
            case .loadCharactersButtonTapped:
                state.isLoading = true
                state.showWelcomeMessage = false
                let currentPage = state.currentPage
                return .run { send in
                    let result = try await apiClient.getCharactersForPage(currentPage)
                    await send(.charactersResponseReceived(result))
                }
            case .charactersResponseReceived(.success(let success)):
                state.info = success.info
                state.characters = success.results
                state.isLoading = false
                return .run { send in
                    await send(.charactersSorted)
                }
            case .charactersResponseReceived(.failure(let apiError)):
                state.error = apiError.localizedDescription
                state.isLoading = false
                return .none
            case .resetButtonTapped:
                state = CharactersListFeature.State()
                return .none
            case .nextPageButtonTapped:
                let pageToLoad = state.currentPage + 1
                if state.info.next != nil {
                    state.isLoading = true
                    state.currentPage = pageToLoad
                    return .run { send in
                        let result = try await apiClient.getCharactersForPage(pageToLoad)
                        await send(.charactersResponseReceived(result))
                    }
                } else {
                    return .none
                }
            case .previousPageButtonTapped:
                let pageToLoad = state.currentPage - 1
                if state.info.prev != nil {
                    state.isLoading = true
                    state.currentPage = pageToLoad
                    return .run { send in
                        let result = try await apiClient.getCharactersForPage(pageToLoad)
                        await send(.charactersResponseReceived(result))
                    }
                } else {
                    return .none
                }
            case .retryButtonTapped:
                return .run { send in
                    await send(.loadCharactersButtonTapped)
                }
            }
        }
    }
}
