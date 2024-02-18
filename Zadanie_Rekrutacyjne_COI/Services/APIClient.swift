//
//  APIClient.swift
//  Zadanie_Rekrutacyjne_COI
//
//  Created by Krystian Grabowy on 16/02/2024.
//

import Foundation
import ComposableArchitecture

struct APIClient {
    static let baseURL = "https://rickandmortyapi.com/api"
    var getCharactersForPage: (Int) async throws -> Result<CharactersResponse, APIError>
    var getEpisodeByID: (Int) async throws -> Result<Episode, APIError>
}

extension APIClient: DependencyKey {
    static var liveValue = APIClient(
        getCharactersForPage: { page in
            guard let url = URL(string: "\(baseURL)/character?page=\(page)") else {
                return .failure(.urlError)
            }
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    return .failure(.httpResponseError)
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(CharactersResponse.self, from: data)
                    return .success(decodedResponse)
                } catch {
                    return .failure(.decodingError)
                }
            } catch {
                return .failure(.unknownError)
            }
        }, getEpisodeByID: { id in
            guard let url = URL(string: "\(baseURL)/episode/\(id)") else {
                return .failure(.urlError)
            }
            
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    return .failure(.httpResponseError)
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(Episode.self, from: data)
                    return .success(decodedResponse)
                } catch {
                    return .failure(.decodingError)
                }
            } catch {
                return .failure(.unknownError)
            }
        }
    )
}

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
