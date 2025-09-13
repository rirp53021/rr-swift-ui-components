import SwiftUI

/// A reusable card component with customizable styling and content slots
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRCard<Content: View>: View {
    // MARK: - Properties
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let content: Content
    private let style: CardStyle
    private let padding: EdgeInsets
    private let cornerRadius: CGFloat
    private let shadowRadius: CGFloat
    private let shadowOffset: CGSize
    private let shadowColor: Color
    private let backgroundColor: Color
    private let borderColor: Color
    private let borderWidth: CGFloat
    
    // MARK: - Initialization
    
    public init(
        style: CardStyle = .standard,
        padding: EdgeInsets = EdgeInsets(
            top: DesignTokens.Spacing.md,
            leading: DesignTokens.Spacing.md,
            bottom: DesignTokens.Spacing.md,
            trailing: DesignTokens.Spacing.md
        ),
        cornerRadius: CGFloat? = nil,
        shadowRadius: CGFloat? = nil,
        shadowOffset: CGSize? = nil,
        shadowColor: Color? = nil,
        backgroundColor: Color? = nil,
        borderColor: Color? = nil,
        borderWidth: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.style = style
        self.padding = padding
        self.cornerRadius = cornerRadius ?? style.cornerRadius
        self.shadowRadius = shadowRadius ?? style.shadowRadius
        self.shadowOffset = shadowOffset ?? style.shadowOffset
        self.shadowColor = shadowColor ?? Color.clear // Will be set in body using theme
        self.backgroundColor = backgroundColor ?? Color.clear // Will be set in body using theme
        self.borderColor = borderColor ?? Color.clear // Will be set in body using theme
        self.borderWidth = borderWidth ?? style.borderWidth
    }
    
    // MARK: - Body
    
    public var body: some View {
        content
            .padding(padding)
            .background(backgroundColor == Color.clear ? style.backgroundColor(theme: theme) : backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor == Color.clear ? style.borderColor(theme: theme) : borderColor, lineWidth: borderWidth)
            )
            .shadow(
                color: shadowColor == Color.clear ? style.shadowColor(theme: theme) : shadowColor,
                radius: shadowRadius,
                x: shadowOffset.width,
                y: shadowOffset.height
            )
    }
}

// MARK: - Card Style

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension RRCard {
    @MainActor
    enum CardStyle {
        case standard
        case elevated
        case outlined
        case filled
        case flat
        
        var cornerRadius: CGFloat {
            switch self {
            case .standard, .elevated, .filled:
                return DesignTokens.BorderRadius.card
            case .outlined, .flat:
                return DesignTokens.BorderRadius.md
            }
        }
        
        var shadowRadius: CGFloat {
            switch self {
            case .standard:
                return DesignTokens.Elevation.level2.radius
            case .elevated:
                return DesignTokens.Elevation.level3.radius
            case .outlined, .filled, .flat:
                return 0
            }
        }
        
        var shadowOffset: CGSize {
            switch self {
            case .standard:
                return CGSize(width: DesignTokens.Elevation.level2.x, height: DesignTokens.Elevation.level2.y)
            case .elevated:
                return CGSize(width: DesignTokens.Elevation.level3.x, height: DesignTokens.Elevation.level3.y)
            case .outlined, .filled, .flat:
                return CGSize(width: 0, height: 0)
            }
        }
        
        func shadowColor(theme: Theme) -> Color {
            switch self {
            case .standard, .elevated:
                return DesignTokens.Elevation.level2.color
            case .outlined, .filled, .flat:
                return Color.clear
            }
        }
        
        func backgroundColor(theme: Theme) -> Color {
            switch self {
            case .standard, .elevated, .flat:
                return theme.colors.surface
            case .outlined:
                return Color.clear
            case .filled:
                return theme.colors.surfaceVariant
            }
        }
        
        func borderColor(theme: Theme) -> Color {
            switch self {
            case .standard, .elevated, .filled, .flat:
                return Color.clear
            case .outlined:
                return theme.colors.outline
            }
        }
        
        var borderWidth: CGFloat {
            switch self {
            case .standard, .elevated, .filled, .flat:
                return 0
            case .outlined:
                return 1
            }
        }
    }
}

// MARK: - Card with Header/Footer

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRCardWithSlots<Header: View, Content: View, Footer: View>: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let header: Header?
    private let content: Content
    private let footer: Footer?
    private let style: RRCard<Content>.CardStyle
    private let padding: EdgeInsets
    private let cornerRadius: CGFloat
    private let shadowRadius: CGFloat
    private let shadowOffset: CGSize
    private let shadowColor: Color
    private let backgroundColor: Color
    private let borderColor: Color
    private let borderWidth: CGFloat
    
    public init(
        style: RRCard<Content>.CardStyle = .standard,
        padding: EdgeInsets = EdgeInsets(
            top: DesignTokens.Spacing.md,
            leading: DesignTokens.Spacing.md,
            bottom: DesignTokens.Spacing.md,
            trailing: DesignTokens.Spacing.md
        ),
        cornerRadius: CGFloat? = nil,
        shadowRadius: CGFloat? = nil,
        shadowOffset: CGSize? = nil,
        shadowColor: Color? = nil,
        backgroundColor: Color? = nil,
        borderColor: Color? = nil,
        borderWidth: CGFloat? = nil,
        header: (() -> Header)? = nil,
        @ViewBuilder content: () -> Content,
        footer: (() -> Footer)? = nil
    ) {
        self.header = header?()
        self.content = content()
        self.footer = footer?()
        self.style = style
        self.padding = padding
        self.cornerRadius = cornerRadius ?? style.cornerRadius
        self.shadowRadius = shadowRadius ?? style.shadowRadius
        self.shadowOffset = shadowOffset ?? style.shadowOffset
        self.shadowColor = shadowColor ?? Color.clear // Will be set in body using theme
        self.backgroundColor = backgroundColor ?? Color.clear // Will be set in body using theme
        self.borderColor = borderColor ?? Color.clear // Will be set in body using theme
        self.borderWidth = borderWidth ?? style.borderWidth
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let header = header {
                header
                    .padding(.horizontal, padding.leading)
                    .padding(.top, padding.top)
            }
            
            content
                .padding(.horizontal, padding.leading)
                .padding(.vertical, header != nil || footer != nil ? DesignTokens.Spacing.sm : padding.top)
            
            if let footer = footer {
                footer
                    .padding(.horizontal, padding.leading)
                    .padding(.bottom, padding.bottom)
            }
        }
        .background(backgroundColor == Color.clear ? style.backgroundColor(theme: theme) : backgroundColor)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor == Color.clear ? style.borderColor(theme: theme) : borderColor, lineWidth: borderWidth)
        )
        .shadow(
            color: shadowColor == Color.clear ? style.shadowColor(theme: theme) : shadowColor,
            radius: shadowRadius,
            x: shadowOffset.width,
            y: shadowOffset.height
        )
    }
}

// MARK: - Preview

#if DEBUG
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct RRCard_Previews: PreviewProvider {
    static var previews: some View {
        RRCardPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRCard Examples")
    }
}

private struct RRCardPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                // Basic cards
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Basic Cards", style: .subtitle, weight: .bold, color: .primary)
                    
                    RRCard {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            RRLabel("Standard Card", style: .subtitle, weight: .bold, color: .primary)
                            RRLabel("This is a standard card with default styling.", style: .body, weight: .regular, color: .secondary)
                        }
                    }
                    
                    RRCard(style: .elevated) {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            RRLabel("Elevated Card", style: .subtitle, weight: .bold, color: .primary)
                            RRLabel("This card has a more prominent shadow.", style: .body, weight: .regular, color: .secondary)
                        }
                    }
                    
                    RRCard(style: .outlined) {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            RRLabel("Outlined Card", style: .subtitle, weight: .bold, color: .primary)
                            RRLabel("This card has a border instead of shadow.", style: .body, weight: .regular, color: .secondary)
                        }
                    }
                }
                
                // Card with slots
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Cards with Header/Footer", style: .subtitle, weight: .bold, color: .primary)
                    
                    RRCardWithSlots(
                        header: {
                            HStack {
                                RRLabel("Header", style: .subtitle, weight: .bold, color: .primary)
                                Spacer()
                                Image(systemName: "ellipsis")
                                    .foregroundColor(theme.colors.onSurfaceVariant)
                            }
                        },
                        content: {
                            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                                RRLabel("Card Content", style: .body, weight: .medium, color: .primary)
                                RRLabel("This card has both header and footer sections.", style: .body, weight: .regular, color: .secondary)
                            }
                        },
                        footer: {
                            HStack {
                                Button("Cancel") { }
                                    .foregroundColor(theme.colors.onSurfaceVariant)
                                Spacer()
                                Button("Save") { }
                                    .foregroundColor(theme.colors.primary)
                            }
                        }
                    )
                }
            }
            .padding(DesignTokens.Spacing.componentPadding)
        }
    }
}
#endif
