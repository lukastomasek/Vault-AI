//
//  IndicatorView.swift
//  vault-ai
//
//  Created by Lukas Tomasek on 2025-12-20.
//

import Foundation
import SnapKit
import UIKit

final class IndicatorView: View {
    enum Constants {
        static let size: CGFloat = 44.0
        static let color: UIColor = DesignSystem.Colors.primaryBlue
    }

    enum Direction {
        case none
        case left
        case right
    }

    private let indicatorView = UIActivityIndicatorView(style: .medium)

    override func setupView() {
        super.setupView()

        indicatorView.hidesWhenStopped = true
        indicatorView.color = Constants.color

        addSubview(indicatorView)
    }

    override func setupConstraints() {
        super.setupConstraints()

        indicatorView.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.size)
            make.center.equalToSuperview()
        }
    }

    func setDirection(_ dir: Direction) {
        indicatorView.snp.remakeConstraints { make in
            if dir == .right {
                make.trailing.equalToSuperview()
                make.leading.greaterThanOrEqualToSuperview()
            } else if dir == .left {
                make.leading.equalToSuperview()
                make.trailing.lessThanOrEqualToSuperview()
            }
            make.width.height.equalTo(Constants.size)
        }
    }

    func start() {
        indicatorView.startAnimating()
    }

    func stop() {
        indicatorView.stopAnimating()
    }
}
