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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        becomeFirstResponder()
        chatInputBar.focus()
    }

    private func setupConstraints() {}
}
