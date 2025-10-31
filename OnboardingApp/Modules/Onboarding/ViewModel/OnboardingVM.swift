//
//  OnboardingVM.swift
//  OnboardingApp
//
//  Created by Yaroslav Homziak on 30.10.2025.
//

import Foundation
import RxSwift
import RxCocoa

class OnboardingVM {
    
    weak var coordinator: OnboardingCoordinator?
    
    let selectAnswerTrigger = PublishRelay<Int>()
    let continueTrigger = PublishRelay<Void>()
    let error = PublishRelay<Error>()
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    let currentQuestion: BehaviorRelay<OnboardingItem?> = BehaviorRelay(value: nil)
    let isContinueEnable: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    private let disposeBag = DisposeBag()
    
    private var currentQuestionIndex = 0
    private var questions: [OnboardingItem] = []
    private var answers: [String: String] = [:]
    
    private let onboardingService: OnboardingServiceProtocol
    
    
    init(onboardingService: OnboardingServiceProtocol) {
        self.onboardingService = onboardingService
        setupBindings()
        loadQuestionList()
    }
    
    private func loadQuestionList() {
        isLoading.accept(true)
        Task {
            do {
                let fetchedQuestions = try await onboardingService.fetchQuestions()
                
                await MainActor.run {
                    self.questions = fetchedQuestions
                    self.currentQuestionIndex = 0
                    
                    if let first = self.questions.first {
                        self.currentQuestion.accept(first)
                    }
                    isLoading.accept(false)
                }
                
            } catch {
                await MainActor.run {
                    self.error.accept(error)
                    isLoading.accept(false)
                }
            }
        }
    }
    
    private func setupBindings() {
        
        selectAnswerTrigger.subscribe { [weak self] index in
            self?.handleAnswerSelection(index)
        }.disposed(by: disposeBag)
        
        continueTrigger.subscribe { [weak self] _ in
            self?.handleContinueTapped()
        }.disposed(by: disposeBag)
    }
    
    private func handleAnswerSelection(_ index: Int) {
        let currentItem = questions[currentQuestionIndex]
        answers.updateValue(currentItem.answers[index], forKey: currentItem.question)
        
        isContinueEnable.accept(true)
    }
    
    private func handleContinueTapped() {
        let isLast = currentQuestionIndex == questions.count - 1
        if isLast {
            //TODO: Send answers to analytic
            coordinator?.showPaywall()
        } else {
            toNextQuestion()
        }
    }
    
    private func toNextQuestion() {
        currentQuestionIndex += 1
        isContinueEnable.accept(false)
        
        if currentQuestionIndex < questions.count {
            currentQuestion.accept(questions[currentQuestionIndex])
        }
    }
}
