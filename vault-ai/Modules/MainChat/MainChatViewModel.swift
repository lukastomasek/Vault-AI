//
//  MainChatViewModel.swift
//  vault-ai
//
//  Created by Lukas Tomasek on 2025-11-19.
//

import Foundation
import UIKit

protocol MainChatViewModelProtocolInput {}

protocol MainChatViewModelProtocolOutput {
    func mockOutgoingMessage() -> ConversationBubbleView.UIModel
    func mockIncomingMessage() -> ConversationBubbleView.UIModel
}

protocol MainChatViewModelProtocol {
    var input: MainChatViewModelProtocolInput { get }
    var output: MainChatViewModelProtocolOutput { get }
}

final class MainChatViewModel: MainChatViewModelProtocol, MainChatViewModelProtocolInput, MainChatViewModelProtocolOutput {
    var input: MainChatViewModelProtocolInput { self }
    var output: MainChatViewModelProtocolOutput { self }

    private let llmService: LLMServiceProtocol

    init() {
        llmService = LLMService() as LLMServiceProtocol
    }

    func mockOutgoingMessage() -> ConversationBubbleView.UIModel {
        .init(text: "Hi, I'm setting up a new screen and need the specifications for a primary button and a headline.", state: .outgoing)
    }

    func mockIncomingMessage() -> ConversationBubbleView.UIModel {
        .init(text: "Certainly! I can grab those values from the DesignSystem for you.", state: .incoming)
    }
}
