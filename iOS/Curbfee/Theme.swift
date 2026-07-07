import SwiftUI

/// civic slate blue with concrete grey, neighborhood-official feel
enum Theme {
    static let accent = Color(red: 0.1725, green: 0.3725, blue: 0.5412)
    static let accentSecondary = Color(red: 0.6902, green: 0.7451, blue: 0.7725)
    static let background = Color(red: 0.0588, green: 0.0863, blue: 0.1255)
    static let cardBackground = background.opacity(0.6)

    static let titleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)

    static let cornerRadius: CGFloat = 16
}
