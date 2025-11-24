//
//  MainChatViewController.swift
//  vault-ai
//
//  Created by Lukas Tomasek on 2025-11-19.
//

import Foundation
import SnapKit
import UIKit

class MainChatViewController: UIViewController {
    private let viewModel: MainChatViewModelProtocol

    private let chatInputBar = ChatInputBar()

    override var inputAccessoryView: UIView? { chatInputBar }
    override var canBecomeFirstResponder: Bool { true }

    private let testOutgoingMessageView = ConversationBubbleView(
        config: .init(
            backgroundColor: DesignSystem.Colors.primaryBlue, textColor: .white
        )
    )

    private let testIncomingMessageView = ConversationBubbleView(
        config: .init(
            backgroundColor: DesignSystem.Colors.backgroundDefault, textColor: .black
        )
    )

    private let scrollView = UIScrollView()
    private let mainStackView = UIStackView()

    // MARK: - Initialization

    init(viewModel: MainChatViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    private func setupView() {
        view.backgroundColor = .white

        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false

        mainStackView.axis = .vertical
        mainStackView.spacing = DesignSystem.Spacing.m
        mainStackView.alignment = .fill
        mainStackView.distribution = .fillProportionally
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = .init(
            top: .zero,
            left: DesignSystem.Spacing.m,
            bottom: DesignSystem.Spacing.m,
            right: DesignSystem.Spacing.m
        )

        testIncomingMessageView.bind(with: viewModel.output.mockIncomingMessage())
        testOutgoingMessageView.bind(with: viewModel.output.mockOutgoingMessage())

        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)

        mainStackView.addArrangedSubview(testOutgoingMessageView)
        mainStackView.addArrangedSubview(testIncomingMessageView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        becomeFirstResponder()
        chatInputBar.focus()
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.snp.width)
        }

        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.snp.width)
        }
    }
}
