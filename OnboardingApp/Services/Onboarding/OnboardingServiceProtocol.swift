//
//  OnboardingServiceProtocol.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 29.10.2025.
//
protocol OnboardingServiceProtocol {
    func fetchQuestions() async throws -> [OnboardingItem]
}
