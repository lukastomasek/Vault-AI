//
//  ConversationBubbleView.swift
//  vault-ai
//
//  Created by Lukas Tomasek on 2025-11-23.
//

import Combine
import Foundation
import SnapKit
import UIKit

final class ConversationBubbleView: View {
    // MARK: - Properties

    struct Configuration {
        let backgroundColor: UIColor
        let textColor: UIColor

        init(backgroundColor: UIColor, textColor: UIColor) {
            self.backgroundColor = backgroundColor
            self.textColor = textColor
        }
    }

    enum State {
        case incoming
        case outgoing
    }

    struct UIModel {
        var text: String
        let state: State
        let copyActionEnabled: Bool

        init(
            text: String,
            state: State,
            copyActionEnabled: Bool = true
        ) {
            self.text = text
            self.state = state
            self.copyActionEnabled = copyActionEnabled
        }
    }

    private let config: Configuration

    private let copyByttonTappedSubject = PassthroughSubject<String, Never>()
    public var copyButtonTappedPublisher: AnyPublisher<String, Never> { copyByttonTappedSubject.eraseToAnyPublisher()
    }

    // MARK: - UI Elements

    private let textLabel = UILabel()
    private let copyButton = UIButton()

    private let containerView = UIView()
    private let buttonStackView = UIStackView()

    // MARK: Init

    init(config: Configuration) {
        self.config = config
        super.init()
    }

    override func setupView() {
        super.setupView()

        containerView.layer.cornerRadius = DesignSystem.Buttons.cornerRadius

        textLabel.font = DesignSystem.Typography.bodyL.font
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 0

        buttonStackView.spacing = DesignSystem.Spacing.m
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fill
        buttonStackView.alignment = .center

        addSubview(containerView)
        addSubview(buttonStackView)
        containerView.addSubview(textLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        applyShadow(to: containerView)
    }

    override func setupConstraints() {
        super.setupConstraints()

        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(44.0)
        }

        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(DesignSystem.Spacing.m)
        }

        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.75)
        }

        setupButtons()
    }

    func bind(with uiModel: UIModel) {
        textLabel.text = uiModel.text
        textLabel.textColor = config.textColor
        containerView.backgroundColor = config.backgroundColor

        let showCopyButton = uiModel.copyActionEnabled
        copyButton.isHidden = !showCopyButton

        containerView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.75)

            switch uiModel.state {
            case .outgoing:
                make.trailing.equalToSuperview()
                make.leading.greaterThanOrEqualToSuperview()
            case .incoming:
                make.leading.equalToSuperview()
                make.trailing.lessThanOrEqualToSuperview()
            }
        }

        buttonStackView.snp.remakeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(DesignSystem.Spacing.xs)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.height.equalTo(22.0)
        }

        setNeedsLayout()
        layoutIfNeeded()
    }
}

extension ConversationBubbleView {
    private func setupButtons() {
        let copyIcon = UIImage(systemName: "doc.on.doc")
        copyButton.setImage(copyIcon, for: .normal)
        copyButton.tintColor = .lightGray
        copyButton.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
        copyButton.setContentHuggingPriority(.required, for: .horizontal)
        copyButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        buttonStackView.addArrangedSubview(copyButton)

        copyButton.snp.makeConstraints { make in
            make.width.height.equalTo(22.0)
        }
    }

    @objc private func copyButtonTapped() {
        Haptics.impact(.light)
        copyByttonTappedSubject.send(textLabel.text ?? "")
    }
}
