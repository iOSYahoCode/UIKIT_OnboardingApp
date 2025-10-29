//
//  NetworkManager.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 29.10.2025.
//

import Foundation
class NetworkManager {
    
    private let decoder = JSONDecoder()
    
    func fetchData<T: Codable>(urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard response.statusCode == 200 else {
            throw NetworkError.serverError(response.statusCode)
        }
        do {
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
