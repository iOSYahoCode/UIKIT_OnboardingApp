//
//  PaywallVM.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 30.10.2025.
//

import Foundation
import RxSwift
import RxCocoa
import StoreKit

class PaywallVM {
    
    private let disposBag = DisposeBag()
    
    var coordinator: PaywallCoordinator?
    
    let subscriptionService = SubscriptionService.shared
    let startNowTrigger = PublishRelay<Void>()
    let cancelTrigger = PublishRelay<Void>()
    
    let product = BehaviorRelay<Product?>(value: nil)
    let hasActiveSubscription = BehaviorRelay<Bool>(value: false)
    let error = PublishRelay<Error>()
    
    
    init() {
        setupBindings()
        restoreAndLoadProducts()
    }
    
    private func setupBindings() {
        cancelTrigger.subscribe { [weak self] _ in
            self?.coordinator?.cancel()
        }.disposed(by: disposBag)
        
        startNowTrigger.subscribe { [weak self] _ in
            self?.handlePurchase()
        }.disposed(by: disposBag)
    }
    
    private func restoreAndLoadProducts() {
        
        Task { @MainActor in
            do {
                await subscriptionService.restorePurchase()
                hasActiveSubscription.accept(subscriptionService.hasActiveSubscriptions)
                
                try await subscriptionService.loadProducts()
                if let first = subscriptionService.products.value.first {
                    product.accept(first)
                }
            } catch {
                self.error.accept(error)
            }
        }
    }
    
    private func handlePurchase() {
        if hasActiveSubscription.value {
            error.accept(SubscriptionError.alreadySubscribed)
            //TODO: Can call coordinator?.finish()
            return
        }
        
        guard let product = product.value else {
            error.accept(SubscriptionError.productNotFound)
            return
        }
        
        Task { @MainActor in
            do {
                try await subscriptionService.purchase(product)
                coordinator?.finish()
            } catch {
                self.error.accept(SubscriptionError.verificationFailed)
            }
        }
    }
}
