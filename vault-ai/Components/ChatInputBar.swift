//
//  Untitled.swift
//  vault-ai
//
//  Created by Lukas Tomasek on 2025-11-19.
//

import Combine
import SnapKit
import UIKit

final class ChatInputBar: View {
    private let textField = InsetTextField()
    private let sendButton = UIButton()

    private let onTextDidChangeSubject = PassthroughSubject<String, Never>()
    public var onTextDidChangePublisher: AnyPublisher<String, Never> { onTextDidChangeSubject.eraseToAnyPublisher()
    }

    private let onSendSubject = PassthroughSubject<String, Never>()
    public var onSendPublisher: AnyPublisher<String, Never> {
        onSendSubject.eraseToAnyPublisher()
    }

    private var isInputFocused: Bool = false {
        didSet {
            applyState()
        }
    }

    // MARK: Init

    override func setupView() {
        backgroundColor = .white

        textField.font = DesignSystem.InputFields.font
        textField.textAlignment = .left
        textField.textColor = .black
        textField.placeholder = "Ask me anything!"
        textField.layer.cornerRadius = DesignSystem.InputFields.standardHeight / 2.0
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.backgroundColor = DesignSystem.Colors.backgroundDefault
        textField.textInsets = .init(
            top: .zero,
            left: DesignSystem.Spacing.s,
            bottom: .zero,
            right: DesignSystem.Buttons.Primary.standardHeight + DesignSystem.Spacing.m
        )

        let imgConfig = UIImage.SymbolConfiguration(pointSize: 22.0, weight: .medium)
        sendButton.backgroundColor = DesignSystem.Buttons.Primary.backgroundColor
        sendButton.layer.cornerRadius = DesignSystem.Buttons.Primary.standardHeight / 2.0
        sendButton.setImage(
            UIImage(systemName: "arrow.up.circle", withConfiguration: imgConfig),
            for: .normal
        )
        sendButton.tintColor = .white

        addSubview(textField)
        addSubview(sendButton)
    }

    override func setupConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(150.0)
        }

        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(DesignSystem.InputFields.standardHeight)
            make.leading.trailing.equalToSuperview().inset(DesignSystem.InputFields.horizontalPadding)
        }

        sendButton.snp.makeConstraints { make in
            make.width.height.equalTo(DesignSystem.Buttons.Primary.standardHeight)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(textField.snp.trailing).offset(-DesignSystem.Spacing.xs)
        }
    }

    override func setupBindings() {
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        textField.addTarget(self, action: #selector(didBeginEditing), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
    }

    private func applyState() {
        UIView.animate(withDuration: 0.25, delay: .zero, options: [.curveEaseInOut, .allowUserInteraction]) {
            if self.isInputFocused {
            } else {
                self.textField.layer.borderColor = UIColor.lightGray.cgColor
                self.textField.backgroundColor = DesignSystem.Colors.backgroundDefault
            }
            self.textField.layoutIfNeeded()
        }
    }

    @objc func textDidChange() {
        let text = textField.text ?? ""
        onTextDidChangeSubject.send(text)
    }

    @objc func sendTapped() {
        Haptics.impact()
        let text = textField.text ?? ""
        onSendSubject.send(text)
    }

    @objc func didBeginEditing() {
        isInputFocused = true
    }

    @objc func didEndEditing() {
        isInputFocused = false
    }

    public func focus() {
        textField.becomeFirstResponder()
        isInputFocused = true
    }

    public func blur() {
        textField.resignFirstResponder()
        textField.endEditing(true)
        isInputFocused = false
    }

    public func setText(_ text: String) {
        textField.text = text
    }

    public func clear() {
        textField.text = ""
    }

    public func setLoadingState(_ isLoading: Bool) {
        if isLoading {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
    }
}
