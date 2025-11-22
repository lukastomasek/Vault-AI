import Foundation
import UIKit

public enum Colors {
    static let lightGray: UIColor = .init(hex: "#EFEFEF") ?? .lightGray
    static let primary: UIColor = .init(hex: "#FF4A4A") ?? .red
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let length = hexSanitized.count

        switch length {
        case 6: // RGB (e.g. FF0000)
            self.init(
                red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgb & 0x0000FF) / 255.0,
                alpha: 1.0
            )

        case 8: // ARGB or RGBA (#AARRGGBB or #RRGGBBAA)
            self.init(
                red: CGFloat((rgb & 0xFF00_0000) >> 24) / 255.0,
                green: CGFloat((rgb & 0x00FF_0000) >> 16) / 255.0,
                blue: CGFloat((rgb & 0x0000_FF00) >> 8) / 255.0,
                alpha: CGFloat(rgb & 0x0000_00FF) / 255.0
            )

        default:
            return nil
        }
    }
}
