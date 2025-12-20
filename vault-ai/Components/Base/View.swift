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

    func applyShadow(
        opacity: Float = 0.1,
        radius: CGFloat = 4.0,
        offset: CGSize = .init(width: 0, height: 2.0),
        to view: UIView? = nil
    ) {
        if let view {
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = opacity
            view.layer.shadowOffset = offset
            view.layer.shadowRadius = radius

            layer.shadowPath = UIBezierPath(
                roundedRect: view.bounds,
                cornerRadius: view.layer.cornerRadius
            ).cgPath
        } else {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = opacity
            layer.shadowOffset = offset
            layer.shadowRadius = radius

            layer.shadowPath = UIBezierPath(
                roundedRect: bounds,
                cornerRadius: layer.cornerRadius
            ).cgPath
        }

        layer.masksToBounds = false
    }
}
