import SwiftUI

/// A comprehensive label component with different typography styles
public struct RRLabel: View {
    public enum Style {
        case title
        case subtitle
        case body
        case caption
        case overline
    }
    
    public enum Weight {
        case light
        case regular
        case medium
        case semibold
        case bold
        case heavy
    }
    
    public enum Color {
        case primary
        case secondary
        case tertiary
        case success
        case warning
        case error
        case info
    }
    
    private let text: String
    private let style: Style
    private let weight: Weight
    private let color: Color
    private let alignment: TextAlignment
    private let lineLimit: Int?
    
    public init(
        _ text: String,
        style: Style = .body,
        weight: Weight = .regular,
        color: Color = .primary,
        alignment: TextAlignment = .leading,
        lineLimit: Int? = nil
    ) {
        self.text = text
        self.style = style
        self.weight = weight
        self.color = color
        self.alignment = alignment
        self.lineLimit = lineLimit
    }
    
    public var body: some View {
        Text(text)
            .font(font)
            .fontWeight(fontWeight)
            .foregroundColor(textColor)
            .dynamicTypeSize(.large) // Support Dynamic Type
            .multilineTextAlignment(alignment)
            .lineLimit(lineLimit)
    }
    
    // MARK: - Computed Properties
    
    private var font: Font {
        switch style {
        case .title: return .largeTitle
        case .subtitle: return .title2
        case .body: return .body
        case .caption: return .caption
        case .overline: return .caption2
        }
    }
    
    private var fontWeight: Font.Weight {
        switch weight {
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        }
    }
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var textColor: SwiftUI.Color {
        let scheme = colorScheme == .dark ? RRColorScheme.dark : RRColorScheme.light
        
        switch color {
        case .primary: return scheme.neutral.text
        case .secondary: return scheme.neutral.textSecondary
        case .tertiary: return scheme.neutral.textSecondary.opacity(0.7)
        case .success: return scheme.semantic.success
        case .warning: return scheme.semantic.warning
        case .error: return scheme.semantic.error
        case .info: return scheme.semantic.info
        }
    }
}

// MARK: - Convenience Initializers

public extension RRLabel {
    /// Creates a title label
    static func title(
        _ text: String,
        weight: Weight = .bold,
        color: Color = .primary,
        alignment: TextAlignment = .leading
    ) -> RRLabel {
        RRLabel(text, style: .title, weight: weight, color: color, alignment: alignment)
    }
    
    /// Creates a subtitle label
    static func subtitle(
        _ text: String,
        weight: Weight = .semibold,
        color: Color = .primary,
        alignment: TextAlignment = .leading
    ) -> RRLabel {
        RRLabel(text, style: .subtitle, weight: weight, color: color, alignment: alignment)
    }
    
    /// Creates a body label
    static func body(
        _ text: String,
        weight: Weight = .regular,
        color: Color = .primary,
        alignment: TextAlignment = .leading
    ) -> RRLabel {
        RRLabel(text, style: .body, weight: weight, color: color, alignment: alignment)
    }
    
    /// Creates a caption label
    static func caption(
        _ text: String,
        weight: Weight = .regular,
        color: Color = .secondary,
        alignment: TextAlignment = .leading
    ) -> RRLabel {
        RRLabel(text, style: .caption, weight: weight, color: color, alignment: alignment)
    }
    
    /// Creates an overline label
    static func overline(
        _ text: String,
        weight: Weight = .medium,
        color: Color = .secondary,
        alignment: TextAlignment = .leading
    ) -> RRLabel {
        RRLabel(text, style: .overline, weight: weight, color: color, alignment: alignment)
    }
}

// MARK: - Preview

#if DEBUG
struct RRLabel_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Different styles
            RRLabel.title("This is a Title")
            RRLabel.subtitle("This is a Subtitle")
            RRLabel.body("This is body text that can span multiple lines and provides the main content for your interface.")
            RRLabel.caption("This is caption text")
            RRLabel.overline("OVERLINE TEXT")
            
            Divider()
            
            // Different weights
            VStack(alignment: .leading, spacing: 8) {
                RRLabel.body("Light", weight: .light)
                RRLabel.body("Regular", weight: .regular)
                RRLabel.body("Medium", weight: .medium)
                RRLabel.body("Semibold", weight: .semibold)
                RRLabel.body("Bold", weight: .bold)
                RRLabel.body("Heavy", weight: .heavy)
            }
            
            Divider()
            
            // Different colors
            VStack(alignment: .leading, spacing: 8) {
                RRLabel.body("Primary", color: .primary)
                RRLabel.body("Secondary", color: .secondary)
                RRLabel.body("Tertiary", color: .tertiary)
                RRLabel.body("Success", color: .success)
                RRLabel.body("Warning", color: .warning)
                RRLabel.body("Error", color: .error)
                RRLabel.body("Info", color: .info)
            }
        }
        .padding()
        .previewDisplayName("RRLabel")
    }
}
#endif
