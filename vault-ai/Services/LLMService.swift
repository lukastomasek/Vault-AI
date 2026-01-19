//
//  LLMService.swift
//  vault-ai
//
//  Created by Lukas Tomasek on 2025-11-09.
//

import Combine
import Foundation
import FoundationModels

protocol LLMServiceProtocol {
    func initialize() -> LLMState
    func resetConversation()
    func getCurrentTranscript() -> Transcript?
    func generateResponse(for prompt: String) -> AnyPublisher<String, Error>
}

struct LLMConfiguration {
    let defaultinstructions: String
    let temperature: Double
    let maxTokenCount: Int?
}

enum LLMState: Equatable {
    case success
    case failure(message: String)
}

final class LLMService: LLMServiceProtocol {
    private let config: LLMConfiguration
    private var isInitialized: Bool = false
    private var currentSession: LanguageModelSession?

    init(
        config: LLMConfiguration =
            .init(
                defaultinstructions: """
                Keep the conversatioon concise and make them build naturally
                from the given topic.
                """,
                temperature: 1.0,
                maxTokenCount: 514
            ))
    {
        self.config = config
    }

    func initialize() -> LLMState {
        let model = SystemLanguageModel.default

        var state: LLMState = .success

        switch model.availability {
        case .available:
            print("SYSML: Available")
            currentSession = LanguageModelSession(
                tools: [CurrentDateTool()],
                instructions: config.defaultinstructions
            )
            state = .success
        case .unavailable(.deviceNotEligible):
            print("SYSML: Unavailable: Device not eligible")
            state = .failure(message: "Device not eligible")
        case .unavailable(.appleIntelligenceNotEnabled):
            print("SYSML: Unavailable: Device not eligible")
            state = .failure(message: "Apple Intelligence not enabled")
        case .unavailable(.modelNotReady):
            print("SYSML: Unavailable: Model not ready")
            state = .failure(message: "Model not ready")
        case let .unavailable(other):
            print("SYSML: Unavailable: \(other)")
            state = .failure(message: "Apple Intelligence unavailable \(other)")
        }

        isInitialized = true

        return state
    }

    func generateResponse(for prompt: String) -> AnyPublisher<String, Error> {
        if !isInitialized {
            print("Must call initialize() before using LLMService")
            return Fail(error: NSError(domain: "LLMService is not initialized", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }

        let options = GenerationOptions(
            temperature: config.temperature,
            maximumResponseTokens: config.maxTokenCount
        )

        return Deferred {
            Future { promise in
                Task {
                    do {
                        let response = try await self.currentSession?.respond(to: prompt, options: options)
                        promise(.success(response?.content ?? ""))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }

    func resetConversation() {
        currentSession = LanguageModelSession(instructions: config.defaultinstructions)
    }

    func getCurrentTranscript() -> Transcript? {
        currentSession?.transcript
    }
}
