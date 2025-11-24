//
//  ConversationBubbleView.swift
//  vault-ai
//
//  Created by Lukas Tomasek on 2025-11-23.
//

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
        let text: String
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

    // MARK: - UI Elements

    private let textLabel = UILabel()
    private let containerView = UIView()

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

        addSubview(containerView)
        containerView.addSubview(textLabel)
    }

    override func setupConstraints() {
        super.setupConstraints()

        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(DesignSystem.Spacing.m)
        }

        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.75)
        }
    }

    func bind(with uiModel: UIModel) {
        textLabel.text = uiModel.text
        textLabel.textColor = config.textColor
        containerView.backgroundColor = config.backgroundColor

        containerView.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
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

        setNeedsLayout()
        layoutIfNeeded()
    }
}
