//
//  NetworkManagerTest.swift
//  OnboardingAppTests
//
//  Created by Yaroslav Homziak on 29.10.2025.
//

import XCTest
@testable import OnboardingApp

final class NetworkManagerTest: XCTestCase {

    func testFetchOnboardingData() async throws {
        
        //Arrage
        let networkManager = await NetworkManager()
        
        //Act
        
        let receivedData: OnboardingResponse = try await networkManager.fetchData(urlString: APIEndpoint.onboardingURL)
        
        //Assert
        
        XCTAssertFalse(receivedData.items.isEmpty, "Expect at least one item in onboarding data")
        XCTAssertNotNil(receivedData.items.first?.question, "Expect question in first item of onboarding data")
    }
}
