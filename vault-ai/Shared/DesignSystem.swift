//
//  DesignSystem.swift
//  vault-ai
//
//  Created by Lukas Tomasek on 2025-11-23.
//

import Foundation
import UIKit

// MARK: - Design System

final class DesignSystem {
    static let shared = DesignSystem()

    // Private initializer to enforce singleton usage
    private init() {}

    // --- 1. Typography Styles (Helvetica Neue) ---
    // Note: iOS/UIKit uses UIFont and doesn't inherently support 'Font Weight' in the same way
    // without specific font files, but we can map to system weights/styles that resemble them.
    // The sizes (Size & Line Height) are implemented as properties.
    enum Typography {
        // --- Display Styles (Size: 48, Line Height: 58) ---
        static let displayXL: (font: UIFont, lineHeight: CGFloat) = (
            font: .systemFont(ofSize: 48, weight: .bold), // Assuming 'Bold' for Display XL
            lineHeight: 58
        )
        static let displayL: (font: UIFont, lineHeight: CGFloat) = (
            font: .systemFont(ofSize: 48, weight: .semibold), // Assuming 'Semibold' for Display L
            lineHeight: 58
        )

        // --- Heading Styles (Size: 32, Line Height: 40) ---
        static let headingXL: (font: UIFont, lineHeight: CGFloat) = (
            font: .systemFont(ofSize: 32, weight: .bold),
            lineHeight: 40
        )
        static let headingL: (font: UIFont, lineHeight: CGFloat) = (
            font: .systemFont(ofSize: 32, weight: .semibold),
            lineHeight: 40
        )

        // --- Title Styles (Size: 24, Line Height: 32) ---
        static let titleXL: (font: UIFont, lineHeight: CGFloat) = (
            font: .systemFont(ofSize: 24, weight: .bold),
            lineHeight: 32
        )
        static let titleL: (font: UIFont, lineHeight: CGFloat) = (
            font: .systemFont(ofSize: 24, weight: .medium),
            lineHeight: 32
        )

        // --- Body Styles (Size: 16, Line Height: 24) ---
        static let bodyXL: (font: UIFont, lineHeight: CGFloat) = (
            font: .systemFont(ofSize: 16, weight: .bold),
            lineHeight: 24
        )
        static let bodyL: (font: UIFont, lineHeight: CGFloat) = (
            font: .systemFont(ofSize: 16, weight: .regular),
            lineHeight: 24
        )

        // --- Caption Styles (Size: 12, Line Height: 16) ---
        static let captionXL: (font: UIFont, lineHeight: CGFloat) = (
            font: .systemFont(ofSize: 12, weight: .bold),
            lineHeight: 16
        )
        static let captionL: (font: UIFont, lineHeight: CGFloat) = (
            font: .systemFont(ofSize: 12, weight: .regular),
            lineHeight: 16
        )
    }

    // --- 2. Spacing System (Soft Grid, 8-Point Grid) ---
    // All spacing values are represented as CGFloat for use in layout constraints.
    enum Spacing {
        static let xxs: CGFloat = 4.0 // 4px
        static let xs: CGFloat = 8.0 // 8px
        static let s: CGFloat = 12.0 // 12px
        static let m: CGFloat = 16.0 // 16px
        static let l: CGFloat = 24.0 // 24px
        static let xl: CGFloat = 32.0 // 32px
        static let xxl: CGFloat = 48.0 // 48px
        static let xxxl: CGFloat = 64.0 // 64px
    }

    // --- 3. Buttons (Primary & Secondary) ---
    // Define the core appearance properties for the buttons.
    enum Buttons {
        // Shared properties
        static let cornerRadius: CGFloat = 8.0

        // --- Primary Button ---
        enum Primary {
            static let backgroundColor: UIColor = .systemBlue // Replace with your design token color
            static let textColor: UIColor = .white
            static let font = DesignSystem.Typography.bodyXL.font // Using Body XL bold font

            // Padding (Horizontal: 24, Vertical: 12)
            static let verticalPadding: CGFloat = DesignSystem.Spacing.s
            static let horizontalPadding: CGFloat = DesignSystem.Spacing.l

            // Standard Height = Vertical Padding * 2 + Font Size (12*2 + 16 = 40)
            static let standardHeight: CGFloat = 40.0
        }

        // --- Secondary Button ---
        enum Secondary {
            static let backgroundColor: UIColor = .clear
            static let borderColor: UIColor = .systemBlue // Replace with your design token color
            static let borderWidth: CGFloat = 1.0
            static let textColor: UIColor = .systemBlue // Replace with your design token color
            static let font = DesignSystem.Typography.bodyXL.font // Using Body XL bold font

            // Padding (Horizontal: 24, Vertical: 12)
            static let verticalPadding: CGFloat = DesignSystem.Spacing.s
            static let horizontalPadding: CGFloat = DesignSystem.Spacing.l

            // Standard Height (Same as Primary)
            static let standardHeight: CGFloat = 40.0
        }
    }

    // --- 4. Input Fields (Text Field) ---
    // Define the core appearance properties for input fields.
    enum InputFields {
        static let cornerRadius: CGFloat = 8.0
        static let borderWidth: CGFloat = 1.0
        static let borderColor: UIColor = .lightGray // Replace with your design token color for borders
        static let errorColor: UIColor = .systemRed // Replace with your design token color for errors
        static let font = DesignSystem.Typography.bodyL.font // Using Body L regular font

        // Padding (Horizontal: 16, Vertical: 16)
        static let verticalPadding: CGFloat = DesignSystem.Spacing.m
        static let horizontalPadding: CGFloat = DesignSystem.Spacing.m

        // Standard Height = Vertical Padding * 2 + Font Size (16*2 + 16 = 48)
        static let standardHeight: CGFloat = 48.0
    }

    // --- (Optional) 5. Colors ---
    // Although not in your initial structure, colors are crucial.
    // Assuming you'd define a similar enum for your color palette.
    enum Colors {
        static let primaryBlue = UIColor(red: 0.0, green: 0.47, blue: 1.0, alpha: 1.0) // Example color
        static let textPrimary = UIColor.black
        static let backgroundDefault = UIColor.white
    }
}
