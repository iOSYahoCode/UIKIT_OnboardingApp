//
//  NetworkError.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 29.10.2025.
//

import Foundation
enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case serverError(Int)
    
    var errorDescription: String? {
           switch self {
           case .invalidURL:
               return "Invalid URL. Please try again later."
           case .invalidResponse:
               return "Invalid response from server. Please try again."
           case .decodingError(let error):
               return "Failed to process data: \(error.localizedDescription)"
           case .serverError(let statusCode):
               return "Server error (\(statusCode)). Please try again later."
           }
       }
}
