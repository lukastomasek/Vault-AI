//
//  View.swift
//  vault-ai
//
//  Created by Lukas Tomasek on 2025-11-23.
//

import Foundation
import UIKit

public protocol ViewProtocol {
    func setupView()
    func setupConstraints()
    func setupBindings()
}

public class View: UIView, ViewProtocol {
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

    open func setupView() {}

    open func setupConstraints() {}

    open func setupBindings() {}
}
