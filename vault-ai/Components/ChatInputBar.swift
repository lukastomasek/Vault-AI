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
    private let topSeparator = UIView()
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

        topSeparator.backgroundColor = .lightGray
        textField.font = DesignSystem.InputFields.font
        textField.textAlignment = .left
        textField.textColor = .black
        textField.placeholder = "Ask me anything!"
        textField.layer.cornerRadius = DesignSystem.InputFields.cornerRadius
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.backgroundColor = DesignSystem.Colors.backgroundDefault

        sendButton.backgroundColor = DesignSystem.Buttons.Primary.backgroundColor
        sendButton.layer.cornerRadius = 8.0
        sendButton.setImage(.icSend.withTintColor(.white), for: .normal)

        addSubview(topSeparator)
        addSubview(textField)
        addSubview(sendButton)
    }

    override func setupConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(150.0)
        }

        topSeparator.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.height.equalTo(1.0)
        }

        sendButton.snp.makeConstraints { make in
            make.width.height.equalTo(DesignSystem.Buttons.Primary.standardHeight)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-DesignSystem.Spacing.xs)
        }

        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(DesignSystem.InputFields.standardHeight)
            make.leading.equalToSuperview().offset(DesignSystem.InputFields.horizontalPadding)
            make.trailing.equalTo(sendButton.snp.leading).offset(-DesignSystem.Spacing.xs)
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
                self.textField.layer.borderColor = DesignSystem.Colors.primaryBlue.cgColor
                self.textField.backgroundColor = DesignSystem.Colors.primaryBlue.withAlphaComponent(0.2)
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
