//
//  APIClient.swift
//  Zadanie_Rekrutacyjne_COI
//
//  Created by Krystian Grabowy on 16/02/2024.
//

import Foundation

struct APIClient {
    let baseURL = "https://rickandmortyapi.com/api"
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getCharacters(page: Int) async -> Result<CharactersResponse, APIError> {
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
    }
    
    func getEpisode(byId id: Int) async -> Result<Episode, APIError> {
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
}
