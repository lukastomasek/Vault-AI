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
    var streamPublisher: AnyPublisher<ConversationBubbleView.UIModel, Never> { get }
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

    private let streamSubject = PassthroughSubject<ConversationBubbleView.UIModel, Never>()
    var streamPublisher: AnyPublisher<ConversationBubbleView.UIModel, Never> {
        streamSubject.eraseToAnyPublisher()
    }

    init() {
        llmService = LLMService() as LLMServiceProtocol
        let status = llmService.initialize()

        // TODO: show modal
        switch status {
        case .success:
            print("LLM INIT")
        case let .failure(message):
            print("LLM FAIRURE: \(message)")
        }
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
                    // TODO: show modal
                    print(error)
                }
            } receiveValue: { responseText in
                let uiModel = ConversationBubbleView.UIModel(text: responseText, state: .incoming)
                self.responseSubject.send(uiModel)
                self.initStreaming(uiModel)
            }
            .store(in: &disposeBag)
    }

    private func initStreaming(_ uiModel: ConversationBubbleView.UIModel) {
        streamMessage(uiModel)
            .sink { [weak self] uiModel in
                self?.streamSubject.send(uiModel)
            }.store(in: &disposeBag)
    }

    private func streamMessage(_ uiModel: ConversationBubbleView.UIModel) -> AnyPublisher<ConversationBubbleView.UIModel, Never> {
        let message = uiModel.text

        let words = message
            .split(whereSeparator: { $0.isWhitespace || $0.isNewline })
            .map(String.init)

        let timer = Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()

        return words.publisher
            .zip(timer) // emit one word per timer tick
            .scan("") { partial, pair in
                let word = pair.0
                return partial.isEmpty ? word : "\(partial) \(word)"
            }
            .map { partial in
                var streamed = uiModel
                streamed.text = partial
                return streamed
            }
            .eraseToAnyPublisher()
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
