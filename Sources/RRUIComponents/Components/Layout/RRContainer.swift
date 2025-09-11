import SwiftUI

/// A customizable container component for organizing and constraining content
public struct RRContainer<Content: View>: View {
    
    // MARK: - Properties
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let content: Content
    private let style: ContainerStyle
    private let maxWidth: CGFloat?
    private let alignment: Alignment
    private let padding: EdgeInsets
    private let background: ContainerBackground
    private let border: ContainerBorder
    private let shadow: ContainerShadow
    private let cornerRadius: CGFloat
    
    // MARK: - Initialization
    
    /// Creates a container with the specified content and style
    /// - Parameters:
    ///   - style: The container style
    ///   - maxWidth: The maximum width of the container
    ///   - alignment: The alignment of the content
    ///   - padding: The padding around the content
    ///   - background: The background style
    ///   - border: The border style
    ///   - shadow: The shadow style
    ///   - cornerRadius: The corner radius
    ///   - content: The content to display
    public init(
        style: ContainerStyle = .default,
        maxWidth: CGFloat? = nil,
        alignment: Alignment = .center,
        padding: EdgeInsets = EdgeInsets(
            top: DesignTokens.Spacing.md,
            leading: DesignTokens.Spacing.md,
            bottom: DesignTokens.Spacing.md,
            trailing: DesignTokens.Spacing.md
        ),
        background: ContainerBackground = .surface,
        border: ContainerBorder = .none,
        shadow: ContainerShadow = .none,
        cornerRadius: CGFloat = DesignTokens.BorderRadius.md,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.style = style
        self.maxWidth = maxWidth
        self.alignment = alignment
        self.padding = padding
        self.background = background
        self.border = border
        self.shadow = shadow
        self.cornerRadius = cornerRadius
    }
    
    // MARK: - Body
    
    public var body: some View {
        content
            .frame(maxWidth: effectiveMaxWidth, alignment: alignment)
            .padding(padding)
            .background(backgroundView)
            .overlay(borderView)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: shadowOffset.width,
                y: shadowOffset.height
            )
    }
    
    // MARK: - Computed Properties
    
    private var effectiveMaxWidth: CGFloat? {
        if let maxWidth = maxWidth {
            return maxWidth
        }
        
        switch style {
        case .default:
            return DesignTokens.Layout.containerMaxWidth
        case .narrow:
            return DesignTokens.Layout.containerMaxWidthSmall
        case .wide:
            return DesignTokens.Layout.containerMaxWidthLarge
        case .fullWidth:
            return nil
        case .custom(let width):
            return width
        }
    }
    
    private var backgroundView: some View {
        Group {
            switch background {
            case .none:
                Color.clear
            case .surface:
                theme.colors.surface
            case .surfaceVariant:
                theme.colors.surfaceVariant
            case .background:
                theme.colors.background
            case .primary:
                theme.colors.primary
            case .secondary:
                theme.colors.secondary
            case .custom(let color):
                color
            case .gradient(let colors):
                LinearGradient(
                    colors: colors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }
    
    private var borderView: some View {
        Group {
            switch border {
            case .none:
                EmptyView()
            case .outline:
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(theme.colors.outline, lineWidth: 1)
            case .outlineVariant:
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(theme.colors.outlineVariant, lineWidth: 1)
            case .primary:
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(theme.colors.primary, lineWidth: 2)
            case .custom(let color, let width):
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: width)
            }
        }
    }
    
    private var shadowColor: Color {
        switch shadow {
        case .none:
            return Color.clear
        case .small:
            return theme.colors.outline.opacity(0.1)
        case .medium:
            return theme.colors.outline.opacity(0.15)
        case .large:
            return theme.colors.outline.opacity(0.2)
        case .custom(let color, _, _):
            return color
        }
    }
    
    private var shadowRadius: CGFloat {
        switch shadow {
        case .none:
            return 0
        case .small:
            return 2
        case .medium:
            return 4
        case .large:
            return 8
        case .custom(_, let radius, _):
            return radius
        }
    }
    
    private var shadowOffset: CGSize {
        switch shadow {
        case .none, .small, .medium, .large:
            return CGSize(width: 0, height: 2)
        case .custom(_, _, let offset):
            return offset
        }
    }
}

// MARK: - Container Style

public enum ContainerStyle {
    case `default`
    case narrow
    case wide
    case fullWidth
    case custom(CGFloat)
}

// MARK: - Container Background

public enum ContainerBackground {
    case none
    case surface
    case surfaceVariant
    case background
    case primary
    case secondary
    case custom(Color)
    case gradient([Color])
}

// MARK: - Container Border

public enum ContainerBorder {
    case none
    case outline
    case outlineVariant
    case primary
    case custom(Color, width: CGFloat)
}

// MARK: - Container Shadow

public enum ContainerShadow {
    case none
    case small
    case medium
    case large
    case custom(Color, radius: CGFloat, offset: CGSize)
}

// MARK: - Container Extensions

public extension RRContainer {
    
    /// Creates a card-style container
    static func card(
        padding: EdgeInsets = EdgeInsets(
            top: DesignTokens.Spacing.lg,
            leading: DesignTokens.Spacing.lg,
            bottom: DesignTokens.Spacing.lg,
            trailing: DesignTokens.Spacing.lg
        ),
        @ViewBuilder content: () -> Content
    ) -> RRContainer<Content> {
        RRContainer(
            style: .default,
            padding: padding,
            background: .surface,
            border: .outlineVariant,
            shadow: .small,
            cornerRadius: DesignTokens.BorderRadius.lg,
            content: content
        )
    }
    
    /// Creates a section container
    static func section(
        padding: EdgeInsets = EdgeInsets(
            top: DesignTokens.Spacing.md,
            leading: DesignTokens.Spacing.md,
            bottom: DesignTokens.Spacing.md,
            trailing: DesignTokens.Spacing.md
        ),
        @ViewBuilder content: () -> Content
    ) -> RRContainer<Content> {
        RRContainer(
            style: .default,
            padding: padding,
            background: .surfaceVariant,
            border: .none,
            shadow: .none,
            cornerRadius: DesignTokens.BorderRadius.md,
            content: content
        )
    }
    
    /// Creates a hero container
    static func hero(
        padding: EdgeInsets = EdgeInsets(
            top: DesignTokens.Spacing.xl,
            leading: DesignTokens.Spacing.xl,
            bottom: DesignTokens.Spacing.xl,
            trailing: DesignTokens.Spacing.xl
        ),
        @ViewBuilder content: () -> Content
    ) -> RRContainer<Content> {
        RRContainer(
            style: .wide,
            padding: padding,
            background: .primary,
            border: .none,
            shadow: .large,
            cornerRadius: DesignTokens.BorderRadius.xl,
            content: content
        )
    }
    
    /// Creates a narrow container
    static func narrow(
        padding: EdgeInsets = EdgeInsets(
            top: DesignTokens.Spacing.md,
            leading: DesignTokens.Spacing.md,
            bottom: DesignTokens.Spacing.md,
            trailing: DesignTokens.Spacing.md
        ),
        @ViewBuilder content: () -> Content
    ) -> RRContainer<Content> {
        RRContainer(
            style: .narrow,
            padding: padding,
            background: .surface,
            border: .outlineVariant,
            shadow: .small,
            cornerRadius: DesignTokens.BorderRadius.md,
            content: content
        )
    }
}

// MARK: - Previews

#if DEBUG
struct RRContainer_Previews: PreviewProvider {
    static var previews: some View {
        RRContainerPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRContainer Examples")
    }
}

private struct RRContainerPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                RRLabel.title("Container Examples")
                
                // Basic containers
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Basic Containers", style: .subtitle, weight: .semibold)
                    
                    RRContainer {
                        VStack(spacing: DesignTokens.Spacing.sm) {
                            RRLabel("Default Container", style: .subtitle, weight: .semibold)
                            RRLabel("This is a default container with standard styling", style: .body)
                        }
                    }
                    
                    RRContainer(style: .narrow) {
                        VStack(spacing: DesignTokens.Spacing.sm) {
                            RRLabel("Narrow Container", style: .subtitle, weight: .semibold)
                            RRLabel("This is a narrow container", style: .body)
                        }
                    }
                    
                    RRContainer(style: .wide) {
                        VStack(spacing: DesignTokens.Spacing.sm) {
                            RRLabel("Wide Container", style: .subtitle, weight: .semibold)
                            RRLabel("This is a wide container", style: .body)
                        }
                    }
                }
                
                // Styled containers
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Styled Containers", style: .subtitle, weight: .semibold)
                    
                    RRContainer(
                        background: .primary,
                        border: .none,
                        shadow: .medium
                    ) {
                        VStack(spacing: DesignTokens.Spacing.sm) {
                            RRLabel("Primary Container", style: .subtitle, weight: .semibold, customColor: theme.colors.onPrimary)
                            RRLabel("This container has a primary background", style: .body, customColor: theme.colors.onPrimary)
                        }
                    }
                    
                    RRContainer(
                        background: .gradient([theme.colors.primary, theme.colors.secondary]),
                        border: .primary,
                        shadow: .large
                    ) {
                        VStack(spacing: DesignTokens.Spacing.sm) {
                            RRLabel("Gradient Container", style: .subtitle, weight: .semibold, customColor: theme.colors.onPrimary)
                            RRLabel("This container has a gradient background", style: .body, customColor: theme.colors.onPrimary)
                        }
                    }
                }
                
                // Container styles
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Container Styles", style: .subtitle, weight: .semibold)
                    
                    RRContainer.card {
                        VStack(spacing: DesignTokens.Spacing.sm) {
                            RRLabel("Card Container", style: .subtitle, weight: .semibold)
                            RRLabel("This is a card-style container", style: .body)
                        }
                    }
                    
                    RRContainer.section {
                        VStack(spacing: DesignTokens.Spacing.sm) {
                            RRLabel("Section Container", style: .subtitle, weight: .semibold)
                            RRLabel("This is a section-style container", style: .body)
                        }
                    }
                    
                    RRContainer.hero {
                        VStack(spacing: DesignTokens.Spacing.sm) {
                            RRLabel("Hero Container", style: .subtitle, weight: .semibold, customColor: theme.colors.onPrimary)
                            RRLabel("This is a hero-style container", style: .body, customColor: theme.colors.onPrimary)
                        }
                    }
                }
                
                // Custom containers
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Custom Containers", style: .subtitle, weight: .semibold)
                    
                    RRContainer(
                        style: .custom(200),
                        background: .custom(theme.colors.success.opacity(0.1)),
                        border: .custom(theme.colors.success, width: 2),
                        shadow: .custom(theme.colors.success.opacity(0.3), radius: 4, offset: CGSize(width: 0, height: 2))
                    ) {
                        VStack(spacing: DesignTokens.Spacing.sm) {
                            RRLabel("Custom Container", style: .subtitle, weight: .semibold)
                            RRLabel("This is a custom-styled container", style: .body)
                        }
                    }
                }
            }
            .padding(DesignTokens.Spacing.md)
        }
    }
}
#endif
