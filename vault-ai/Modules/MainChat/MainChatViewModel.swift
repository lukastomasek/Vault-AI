//
//  MainChatViewModel.swift
//  vault-ai
//
//  Created by Lukas Tomasek on 2025-11-19.
//

import Foundation
import UIKit

protocol MainChatViewModelProtocolInput {}

protocol MainChatViewModelProtocolOutput {}

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
}
