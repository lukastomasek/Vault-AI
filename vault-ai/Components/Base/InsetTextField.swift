//
//  InsetTextField.swift
//  vault-ai
//
//  Created by Lukas Tomasek on 2025-12-21.
//

import Foundation
import UIKit

class InsetTextField: UITextField {
    var textInsets = UIEdgeInsets(
        top: 0, left: DesignSystem.Spacing.s, bottom: 0, right: DesignSystem.Spacing.s
    )

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
