//
//  MainChatViewController.swift
//  vault-ai
//
//  Created by Lukas Tomasek on 2025-11-19.
//

import Combine
import Foundation
import SnapKit
import UIKit

class MainChatViewController: UIViewController {
    // MARK: Properties

    private let viewModel: MainChatViewModelProtocol

    private var disposeBag = Set<AnyCancellable>()

    // MARK: UI Elements

    private let chatInputBar = ChatInputBar()

    override var inputAccessoryView: UIView? { chatInputBar }
    override var canBecomeFirstResponder: Bool { true }

    private let scrollView = UIScrollView()
    private let mainStackView = UIStackView()
    private var currentIndicatorView: IndicatorView? = nil

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
        setupBindings()
    }

    private func setupView() {
        view.backgroundColor = .white

        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
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

        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        becomeFirstResponder()
        chatInputBar.focus()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateBottomInsetForAccessory()
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }

        mainStackView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
    }

    private func setupBindings() {
        chatInputBar.onSendPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.sendButtonTapped(text)
            }.store(in: &disposeBag)

        viewModel.output.responsePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uiModel in
                self?.createBubbleView(with: uiModel, showIndicator: false)
            }.store(in: &disposeBag)

        viewModel.output.loadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.chatInputBar.setLoadingState(isLoading)
            }.store(in: &disposeBag)
    }

    private func sendButtonTapped(_ text: String) {
        viewModel.input.generateResponse(from: text)

        let uiModel = ConversationBubbleView.UIModel(text: text, state: .outgoing)
        createBubbleView(with: uiModel, showIndicator: true)
        chatInputBar.clear()
    }

    private func updateBottomInsetForAccessory() {
        let accessoryHeight: CGFloat = inputAccessoryView?.bounds.height ?? .zero
        let bottomInset: CGFloat = accessoryHeight + view.safeAreaInsets.bottom

        // Only update if it actually changed (prevents jitter).
        if scrollView.safeAreaInsets.bottom != bottomInset {
            scrollView.contentInset.bottom = bottomInset
            scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
        }
    }
}

// MARK: - Extension

extension MainChatViewController {
    private func createBubbleView(with uiModel: ConversationBubbleView.UIModel, showIndicator: Bool) {
        let configuration: ConversationBubbleView.Configuration
        switch uiModel.state {
        case .incoming:
            configuration = .init(backgroundColor: DesignSystem.Colors.primaryBlue, textColor: .white)
        case .outgoing:
            configuration = .init(backgroundColor: DesignSystem.Colors.backgroundDefault, textColor: .black)
        }

        let messageView = ConversationBubbleView(config: configuration)

        messageView.bind(with: uiModel)
        mainStackView.addArrangedSubview(messageView)

        if showIndicator {
            insertLoadingIndicatorView()
        } else {
            removeIndicatorView()
        }
    }

    private func insertLoadingIndicatorView() {
        let indicatorView = IndicatorView()
        mainStackView.addArrangedSubview(indicatorView)
        indicatorView.setDirection(.left)
        indicatorView.start()
        currentIndicatorView = indicatorView
    }

    func removeIndicatorView() {
        if let currentIndicatorView {
            mainStackView.removeArrangedSubview(currentIndicatorView)
            currentIndicatorView.stop()
            currentIndicatorView.removeFromSuperview()
        }

        currentIndicatorView = nil
    }
}
