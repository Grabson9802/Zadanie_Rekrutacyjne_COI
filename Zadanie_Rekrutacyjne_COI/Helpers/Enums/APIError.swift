//
//  APIError.swift
//  Zadanie_Rekrutacyjne_COI
//
//  Created by Krystian Grabowy on 18/02/2024.
//

enum APIError: Error {
    case urlError
    case decodingError
    case httpResponseError
    case unknownError
}
