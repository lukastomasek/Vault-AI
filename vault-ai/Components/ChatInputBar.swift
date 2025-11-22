//
//  Untitled.swift
//  vault-ai
//
//  Created by Lukas Tomasek on 2025-11-19.
//

import Combine
import SnapKit
import UIKit

final class ChatInputBar: UIView {
    private let topSeparator = UIView()
    private let textField = InsetTextField()
    private let sendButton = UIButton()

    private let onTextDidChangeSubject = PassthroughSubject<String, Never>()
    public var onTextDidChangePublisher: AnyPublisher<String, Never> { onTextDidChangeSubject.eraseToAnyPublisher()
    }

    // MARK: Init

    init() {
        super.init(frame: .zero)

        setupView()
        setupConstraints()
        setupBindings()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .white

        topSeparator.backgroundColor = .lightGray
        textField.font = .systemFont(ofSize: 16.0)
        textField.textAlignment = .left
        textField.placeholder = "Ask me anything!"
        textField.layer.cornerRadius = 8.0
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.backgroundColor = Colors.lightGray

        sendButton.backgroundColor = Colors.primary
        sendButton.layer.cornerRadius = 8.0
        sendButton.setImage(.icSend.withTintColor(.white), for: .normal)

        addSubview(topSeparator)
        addSubview(textField)
        addSubview(sendButton)
    }

    private func setupConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(150.0)
        }

        topSeparator.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.height.equalTo(1.0)
        }

        sendButton.snp.makeConstraints { make in
            make.width.height.equalTo(50.0)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16.0)
        }

        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(50.0)
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.equalTo(sendButton.snp.leading).offset(-8.0)
        }
    }

    private func setupBindings() {
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    @objc func textDidChange() {
        let text = textField.text ?? ""
        onTextDidChangeSubject.send(text)
    }

    public func focus() {
        textField.becomeFirstResponder()
    }

    public func blur() {
        textField.resignFirstResponder()
        textField.endEditing(true)
    }

    public func setText(_ text: String) {
        textField.text = text
    }

    public func clear() {
        textField.text = ""
    }
}

private class InsetTextField: UITextField {
    var textInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

    // For text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    // For editing text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    // For placeholder
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
}
