//
//  SubscriptionService.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 30.10.2025.
//

import Foundation
import StoreKit
import RxSwift
import RxCocoa

@MainActor
class SubscriptionService {
    
    static let shared = SubscriptionService()
    
    private let productIDs = ["com.onboardingapp.weekly"]
    
    let products = BehaviorRelay<[Product]>(value: [])
    let purchasedProductIDs = BehaviorRelay<Set<String>>(value: [])
    
    var hasActiveSubscriptions: Bool {
        return !purchasedProductIDs.value.isEmpty
    }
    
    private init() {
        Task {
            await observeTransactionUpdates()
        }
    }
    
    func loadProducts() async throws {
        let result = try await Product.products(for: productIDs)
        products.accept(result)
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verificationResult):
           
            let transaction = try checkVerified(verificationResult)
            await updatePurchasedProducts()
            await transaction.finish()
        
        case .userCancelled:
            throw SubscriptionError.purchaseFailed
        case .pending:
            throw SubscriptionError.purchaseFailed
        default:
            throw SubscriptionError.purchaseFailed
        }
    }
    
    func restorePurchase() async {
        try? await AppStore.sync()
        await updatePurchasedProducts()
    }
    
    private func observeTransactionUpdates() async {
        for await result in Transaction.updates {
            if let transaction = try? checkVerified(result) {
                await updatePurchasedProducts()
                await transaction.finish()
            }
        }
    }
    
    private func updatePurchasedProducts() async {
        var purchased: Set<String> = []
        
        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result) {
                purchased.insert(transaction.productID)
            }
        }
        
        purchasedProductIDs.accept(purchased)
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, _):
            throw SubscriptionError.vericationFailed
        case .verified(let signedType):
            return signedType
        }
    }
}
