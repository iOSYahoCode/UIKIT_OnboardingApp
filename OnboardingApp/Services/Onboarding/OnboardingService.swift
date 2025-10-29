//
//  OnboardingService.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 29.10.2025.
//

import Foundation
class OnboardingService: OnboardingServiceProtocol {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchQuestions() async throws -> [OnboardingItem] {
        let response: OnboardingResponse = try await networkManager.fetchData(urlString: APIEndpoint.onboardingURL)
        return response.items
    }
}
