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
    
    var coordinator: PaywallCoordinator?
    
    let subscriptionService = SubscriptionService.shared
    let startNowTrigger = PublishRelay<Void>()
    let cancelTrigger = PublishRelay<Void>()
    
    let product = BehaviorRelay<Product?>(value: nil)
    let error = PublishRelay<Error>()
    let disposBag = DisposeBag()
    
    
    init() {
        setupBindings()
        loadProducts()
    }
    
    private func setupBindings() {
        cancelTrigger.subscribe { [weak self] _ in
            self?.coordinator?.cancel()
        }.disposed(by: disposBag)
        
        startNowTrigger.subscribe { [weak self] _ in
            self?.handlePurchase()
        }.disposed(by: disposBag)
    }
    
    private func loadProducts() {
        
        Task { @MainActor in
            do {
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
        guard let product = product.value else {
            error.accept(SubscriptionError.productNotFound)
            return
        }
        
        Task { @MainActor in
            do {
                try await subscriptionService.purchase(product)
                coordinator?.finish()
            } catch {
                self.error.accept(SubscriptionError.vericationFailed)
            }
        }
    }
}
