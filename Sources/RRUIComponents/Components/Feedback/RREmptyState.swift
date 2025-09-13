import SwiftUI

/// A reusable empty state component with illustration, text, and action button
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RREmptyState<Action: View>: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    // MARK: - Properties
    
    private let illustration: Image?
    private let title: String
    private let subtitle: String?
    private let action: Action?
    private let style: EmptyStateStyle
    private let spacing: CGFloat
    private let padding: EdgeInsets
    private let backgroundColor: Color?
    
    // MARK: - Initialization
    
    public init(
        illustration: Image? = nil,
        title: String,
        subtitle: String? = nil,
        style: EmptyStateStyle = .standard,
        spacing: CGFloat = DesignTokens.Spacing.lg,
        padding: EdgeInsets = EdgeInsets(
            top: DesignTokens.Spacing.xl,
            leading: DesignTokens.Spacing.xl,
            bottom: DesignTokens.Spacing.xl,
            trailing: DesignTokens.Spacing.xl
        ),
        backgroundColor: Color? = nil,
        action: (() -> Action)? = nil
    ) {
        self.illustration = illustration
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.spacing = spacing
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.action = action?()
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: spacing) {
            // Illustration
            if let illustration = illustration {
                illustration
                    .foregroundColor(style.illustrationColor(theme: theme))
                    .font(.system(size: style.illustrationSize))
                    .frame(width: style.illustrationSize, height: style.illustrationSize)
            } else {
                defaultIllustration
            }
            
            // Content
            VStack(spacing: DesignTokens.Spacing.xs) {
                RRLabel(title, style: style.titleLabelStyle, weight: .medium, customColor: style.titleColor(theme: theme))
                    .multilineTextAlignment(.center)
                    .dynamicTypeSize(.large) // Support Dynamic Type
                
                if let subtitle = subtitle {
                    RRLabel(subtitle, style: style.subtitleLabelStyle, weight: .regular, customColor: style.subtitleColor(theme: theme))
                        .multilineTextAlignment(.center)
                        .dynamicTypeSize(.large) // Support Dynamic Type
                }
            }
            
            // Action
            if let action = action {
                action
            }
        }
        .padding(padding)
        .background(backgroundColor)
        .cornerRadius(style.cornerRadius)
    }
    
    // MARK: - Default Illustration
    
    private var defaultIllustration: some View {
        Image(systemName: style.defaultIcon)
            .foregroundColor(style.illustrationColor(theme: theme))
            .font(.system(size: style.illustrationSize))
            .frame(width: style.illustrationSize, height: style.illustrationSize)
    }
}

// MARK: - Empty State Style

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension RREmptyState {
    @MainActor
    enum EmptyStateStyle {
        case standard
        case compact
        case prominent
        case minimal
        
        var titleFont: Font {
            switch self {
            case .standard, .compact:
                return .title2
            case .prominent:
                return .largeTitle
            case .minimal:
                return .headline
            }
        }
        
        var titleLabelStyle: RRLabel.Style {
            switch self {
            case .standard, .compact:
                return .title
            case .prominent:
                return .title
            case .minimal:
                return .subtitle
            }
        }
        
        var subtitleFont: Font {
            switch self {
            case .standard, .compact, .prominent:
                return .body
            case .minimal:
                return .caption
            }
        }
        
        var subtitleLabelStyle: RRLabel.Style {
            switch self {
            case .standard, .compact, .prominent:
                return .body
            case .minimal:
                return .caption
            }
        }
        
        func titleColor(theme: Theme) -> Color {
            switch self {
            case .standard, .compact, .prominent, .minimal:
                return theme.colors.onSurface
            }
        }
        
        func subtitleColor(theme: Theme) -> Color {
            switch self {
            case .standard, .compact, .prominent, .minimal:
                return theme.colors.onSurfaceVariant
            }
        }
        
        func illustrationColor(theme: Theme) -> Color {
            switch self {
            case .standard, .compact, .prominent, .minimal:
                return theme.colors.onSurfaceVariant
            }
        }
        
        var illustrationSize: CGFloat {
            switch self {
            case .standard:
                return DesignTokens.ComponentSize.iconSizeXL
            case .compact:
                return DesignTokens.ComponentSize.iconSizeLG
            case .prominent:
                return DesignTokens.ComponentSize.iconSizeXL * 2
            case .minimal:
                return DesignTokens.ComponentSize.iconSizeMD
            }
        }
        
        var defaultIcon: String {
            switch self {
            case .standard, .compact, .prominent, .minimal:
                return "tray"
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .standard, .compact, .prominent:
                return DesignTokens.BorderRadius.lg
            case .minimal:
                return DesignTokens.BorderRadius.md
            }
        }
    }
}

// MARK: - Convenience Initializers

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension RREmptyState where Action == EmptyView {
    init(
        illustration: Image? = nil,
        title: String,
        subtitle: String? = nil,
        style: EmptyStateStyle = .standard,
        spacing: CGFloat = DesignTokens.Spacing.lg,
        padding: EdgeInsets = EdgeInsets(
            top: DesignTokens.Spacing.xl,
            leading: DesignTokens.Spacing.xl,
            bottom: DesignTokens.Spacing.xl,
            trailing: DesignTokens.Spacing.xl
        ),
        backgroundColor: Color? = nil
    ) {
        self.init(
            illustration: illustration,
            title: title,
            subtitle: subtitle,
            style: style,
            spacing: spacing,
            padding: padding,
            backgroundColor: backgroundColor,
            action: nil
        )
    }
}


// MARK: - Preview

#if DEBUG
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct RREmptyState_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.xl) {
                // Standard empty state
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Standard Empty State", style: .title, weight: .bold, color: .primary)
                    
                    RREmptyState(
                        illustration: Image(systemName: "tray"),
                        title: "No Items",
                        subtitle: "There are no items to display at the moment.",
                        style: .standard
                    ) {
                        RRButton("Add Item", style: .primary, size: .md) {
                            print("Add item tapped")
                        }
                    }
                }
                
                // Predefined empty states
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Predefined Empty States", style: .title, weight: .bold, color: .primary)
                    
                    RREmptyState(
                        illustration: Image(systemName: "tray"),
                        title: "No Data",
                        subtitle: "There's nothing to show here yet.",
                        style: .standard
                    ) {
                        RRButton("Refresh", style: .primary, size: .md) {
                            print("Refresh tapped")
                        }
                    }
                    
                    RREmptyState(
                        illustration: Image(systemName: "magnifyingglass"),
                        title: "No Results",
                        subtitle: "Try adjusting your search terms.",
                        style: .standard
                    ) {
                        RRButton("Clear Search", style: .secondary, size: .md) {
                            print("Clear search tapped")
                        }
                    }
                    
                    RREmptyState(
                        illustration: Image(systemName: "wifi.slash"),
                        title: "Connection Error",
                        subtitle: "Check your internet connection and try again.",
                        style: .standard
                    ) {
                        RRButton("Retry", style: .destructive, size: .md) {
                            print("Retry tapped")
                        }
                    }
                }
                
                // Different styles
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Different Styles", style: .title, weight: .bold, color: .primary)
                    
                    RREmptyState(
                        title: "Compact Style",
                        subtitle: "This is a compact empty state.",
                        style: .compact
                    )
                    
                    RREmptyState(
                        title: "Prominent Style",
                        subtitle: "This is a prominent empty state with larger text.",
                        style: .prominent
                    )
                    
                    RREmptyState(
                        title: "Minimal Style",
                        subtitle: "This is a minimal empty state.",
                        style: .minimal
                    )
                }
                
                // Custom empty state
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Custom Empty State", style: .title, weight: .bold, color: .primary)
                    
                    RREmptyState(
                        illustration: Image(systemName: "star.fill"),
                        title: "Custom State",
                        subtitle: "This is a custom empty state with a star icon.",
                        style: .standard,
                        backgroundColor: Color.gray.opacity(0.1)
                    ) {
                        HStack(spacing: DesignTokens.Spacing.sm) {
                            RRButton("Cancel", style: .outline, size: .md) {
                                print("Cancel tapped")
                            }
                            
                            RRButton("Continue", style: .primary, size: .md) {
                                print("Continue tapped")
                            }
                        }
                    }
                }
            }
            .padding(DesignTokens.Spacing.componentPadding)
        }
        .themeProvider(ThemeProvider())
        .previewDisplayName("RREmptyState Examples")
    }
}
#endif
