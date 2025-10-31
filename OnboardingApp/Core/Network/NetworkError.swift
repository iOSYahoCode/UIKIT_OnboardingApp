//
//  NetworkError.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 29.10.2025.
//

import Foundation
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case serverError(Int)
}
