//
//  OnboardingResponseTests.swift
//  OnboardingAppTests
//
//  Created by Yaroslav Homziak on 29.10.2025.
//

import XCTest
@testable import OnboardingApp

final class OnboardingResponseTests: XCTestCase {
    
    func testValidJSONDecoding() throws {
        
        //Arrange
        let jsonData = """
            {
                "items": [
                        {
                            "id": 1,
                            "question": "What's your occupation?",
                            "answers": [
                                "Medicine",
                                "Entrepreneurship",
                                "Retired",
                                "Student",
                                "Employee",
                                "Prefer not to answer & use default settings"
                            ]
                        },
                        {
                            "id": 2,
                            "question": "How old are you?",
                            "answers": [
                                "18-24",
                                "25-34",
                                "35-44",
                                "45-54",
                                "55-65",
                                "65+"
                            ]
                        },
                        {
                            "id": 3,
                            "question": "How did you find this scanner?",
                            "answers": [
                                "Facebook",
                                "Instagram",
                                "Google",
                                "Ads from other app",
                                "Other"
                            ]
                        }
                    ]
                }
            """.data(using: .utf8)
        
        let decoder = JSONDecoder()
        
        //Act
        guard let json = jsonData else {
            throw XCTSkip("No JSON data")
        }
        let response = try decoder.decode(OnboardingResponse.self, from: json)
        
        //Assert
        XCTAssertEqual(response.items.count, 3)
        XCTAssertEqual(response.items[0].question, "What's your occupation?")
        XCTAssertEqual(response.items[0].answers.count, 6)
    }
}
