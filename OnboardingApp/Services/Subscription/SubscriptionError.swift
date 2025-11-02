//
//  SubscriptionError.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 30.10.2025.
//

import Foundation
enum SubscriptionError: LocalizedError {
    case purchaseFailed
    case verificationFailed
    case productNotFound
    case noPurchasesToRestore
    case alreadySubscribed
    
    var errorDescription: String? {
        switch self {
        case .purchaseFailed:
            return "Purchase failed. Please try again."
        case .verificationFailed:
            return "Unable to verify purchase."
        case .productNotFound:
            return "Product not available."
        case .noPurchasesToRestore:
            return "No previous purchases found."
        case .alreadySubscribed:
            return "You already have an active subscription."
        }
    }
}
