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
    private let customColor: SwiftUI.Color?
    private let alignment: TextAlignment
    private let lineLimit: Int?
    
    public init(
        _ text: String,
        style: Style = .body,
        weight: Weight = .regular,
        color: Color = .primary,
        customColor: SwiftUI.Color? = nil,
        alignment: TextAlignment = .leading,
        lineLimit: Int? = nil
    ) {
        self.text = text
        self.style = style
        self.weight = weight
        self.color = color
        self.customColor = customColor
        self.alignment = alignment
        self.lineLimit = lineLimit
    }
    
    public var body: some View {
        Text(text)
            .font(font)
            .fontWeight(fontWeight)
            .foregroundColor(textColor)
            .multilineTextAlignment(alignment)
            .lineLimit(lineLimit)
    }
    
    // MARK: - Computed Properties
    
    private var font: Font {
        switch style {
        case .title: return DesignTokens.Typography.titleLarge
        case .subtitle: return DesignTokens.Typography.titleMedium
        case .body: return DesignTokens.Typography.bodyMedium
        case .caption: return DesignTokens.Typography.bodySmall
        case .overline: return DesignTokens.Typography.labelSmall
        }
    }
    
    private var fontWeight: Font.Weight {
        switch weight {
        case .light: return DesignTokens.Typography.weightLight
        case .regular: return DesignTokens.Typography.weightRegular
        case .medium: return DesignTokens.Typography.weightMedium
        case .semibold: return DesignTokens.Typography.weightSemibold
        case .bold: return DesignTokens.Typography.weightBold
        case .heavy: return DesignTokens.Typography.weightHeavy
        }
    }
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.themeProvider) private var themeProvider
    
    private var textColor: SwiftUI.Color {
        // Use custom color if provided, otherwise use the predefined color
        if let customColor = customColor {
            return customColor
        }
        
        switch color {
        case .primary: return .primaryText
        case .secondary: return .secondary
        case .tertiary: return .tertiary
        case .success: return .success
        case .warning: return .warning
        case .error: return .error
        case .info: return .info
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
        customColor: SwiftUI.Color? = nil,
        alignment: TextAlignment = .leading
    ) -> RRLabel {
        RRLabel(text, style: .title, weight: weight, color: color, customColor: customColor, alignment: alignment)
    }
    
    /// Creates a subtitle label
    static func subtitle(
        _ text: String,
        weight: Weight = .semibold,
        color: Color = .primary,
        customColor: SwiftUI.Color? = nil,
        alignment: TextAlignment = .leading
    ) -> RRLabel {
        RRLabel(text, style: .subtitle, weight: weight, color: color, customColor: customColor, alignment: alignment)
    }
    
    /// Creates a body label
    static func body(
        _ text: String,
        weight: Weight = .regular,
        color: Color = .primary,
        customColor: SwiftUI.Color? = nil,
        alignment: TextAlignment = .leading
    ) -> RRLabel {
        RRLabel(text, style: .body, weight: weight, color: color, customColor: customColor, alignment: alignment)
    }
    
    /// Creates a caption label
    static func caption(
        _ text: String,
        weight: Weight = .regular,
        color: Color = .secondary,
        customColor: SwiftUI.Color? = nil,
        alignment: TextAlignment = .leading
    ) -> RRLabel {
        RRLabel(text, style: .caption, weight: weight, color: color, customColor: customColor, alignment: alignment)
    }
    
    /// Creates an overline label
    static func overline(
        _ text: String,
        weight: Weight = .medium,
        color: Color = .secondary,
        customColor: SwiftUI.Color? = nil,
        alignment: TextAlignment = .leading
    ) -> RRLabel {
        RRLabel(text, style: .overline, weight: weight, color: color, customColor: customColor, alignment: alignment)
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
            
            Divider()
            
            // Custom colors
            VStack(alignment: .leading, spacing: 8) {
                RRLabel.body("Custom Blue", customColor: .blue)
                RRLabel.body("Custom Green", customColor: .green)
                RRLabel.body("Custom Purple", customColor: .purple)
                RRLabel.body("Custom Orange", customColor: .orange)
                RRLabel.body("Custom Pink", customColor: .pink)
                RRLabel.body("Disabled Gray", customColor: .disabled)
            }
        }
        .padding()
        .themeProvider(ThemeProvider())
        .previewDisplayName("RRLabel")
    }
}
#endif
