//
//  MainChatViewModel.swift
//  vault-ai
//
//  Created by Lukas Tomasek on 2025-11-19.
//

import Combine
import Foundation
import UIKit

protocol MainChatViewModelProtocolInput {
    func generateResponse(from inputText: String)
}

protocol MainChatViewModelProtocolOutput {
    func mockOutgoingMessage() -> ConversationBubbleView.UIModel
    func mockIncomingMessage() -> ConversationBubbleView.UIModel

    var loadingPublisher: AnyPublisher<Bool, Never> { get }
    var responsePublisher: AnyPublisher<ConversationBubbleView.UIModel, Never> { get }
}

protocol MainChatViewModelProtocol {
    var input: MainChatViewModelProtocolInput { get }
    var output: MainChatViewModelProtocolOutput { get }
}

final class MainChatViewModel: MainChatViewModelProtocol, MainChatViewModelProtocolInput, MainChatViewModelProtocolOutput {
    var input: MainChatViewModelProtocolInput { self }
    var output: MainChatViewModelProtocolOutput { self }

    private let llmService: LLMServiceProtocol

    private var disposeBag = Set<AnyCancellable>()

    private let responseSubject = PassthroughSubject<ConversationBubbleView.UIModel, Never>()
    var responsePublisher: AnyPublisher<ConversationBubbleView.UIModel, Never> {
        responseSubject.eraseToAnyPublisher()
    }

    private let loadingSubject = PassthroughSubject<Bool, Never>()
    var loadingPublisher: AnyPublisher<Bool, Never> {
        loadingSubject.eraseToAnyPublisher()
    }

    init() {
        llmService = LLMService() as LLMServiceProtocol
        llmService.initialize()
    }

    func generateResponse(from inputText: String) {
        if inputText.isEmpty {
            return
        }

        loadingSubject.send(true)
        llmService.generateResponse(for: inputText)
            .sink { [weak self] completion in
                self?.loadingSubject.send(false)
                if case let .failure(error) = completion {
                    print(error)
                }
            } receiveValue: { responseText in
                let uiModel = ConversationBubbleView.UIModel(text: responseText, state: .incoming)
                self.responseSubject.send(uiModel)
            }
            .store(in: &disposeBag)
    }
}

extension MainChatViewModel {
    func mockOutgoingMessage() -> ConversationBubbleView.UIModel {
        .init(text: "Hi, I'm setting up a new screen and need the specifications for a primary button and a headline.", state: .outgoing)
    }

    func mockIncomingMessage() -> ConversationBubbleView.UIModel {
        .init(text: "Certainly! I can grab those values from the DesignSystem for you.", state: .incoming)
    }
}
