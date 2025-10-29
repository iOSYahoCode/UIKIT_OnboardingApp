//
//  OnboardingItem.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 29.10.2025.
//

import Foundation
struct OnboardingItem: Codable {
    let id: Int
    let question: String
    let answers: [String]
}
