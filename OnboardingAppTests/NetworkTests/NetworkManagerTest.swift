//
//  NetworkManagerTest.swift
//  OnboardingAppTests
//
//  Created by Yaroslav Homziak on 29.10.2025.
//

import XCTest
@testable import OnboardingApp

final class NetworkManagerTest: XCTestCase {

    func testFetchOnboardingData() {
        
        //Arrage
        let networkManager = NetworkManager()
        let expectation = XCTestExpectation(description: "Fetch onboarding data from server")
        
        var receivedData: OnboardingResponse?
        var receivedError: NetworkError?
        
        //Act
        
        Task {
            do {
                receivedData = try await networkManager.fetchData(urlString: APIEndpoint.onboardingURL)
            } catch {
                receivedError = error as? NetworkError
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
        
        //Assert
        
        XCTAssertNotNil(receivedData, "Expect to get onboarding data")
        XCTAssertNil(receivedError, "Expact to not get any error")
        
        if let data = receivedData {
            XCTAssertFalse(data.items.isEmpty, "Expect to get any items in onboarding data")
        }
    }
}
