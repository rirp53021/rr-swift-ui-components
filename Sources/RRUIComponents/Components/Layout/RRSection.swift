import SwiftUI

/// A customizable section component for organizing content into logical groups
public struct RRSection<Header: View, Content: View, Footer: View>: View {
    
    // MARK: - Properties
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let header: Header?
    private let content: Content
    private let footer: Footer?
    private let style: SectionStyle
    private let spacing: CGFloat
    private let padding: EdgeInsets
    private let background: SectionBackground
    private let border: SectionBorder
    private let cornerRadius: CGFloat
    private let showDivider: Bool
    private let dividerStyle: DividerStyle
    
    // MARK: - Initialization
    
    /// Creates a section with the specified content and style
    /// - Parameters:
    ///   - style: The section style
    ///   - spacing: The spacing between header, content, and footer
    ///   - padding: The padding around the section
    ///   - background: The background style
    ///   - border: The border style
    ///   - cornerRadius: The corner radius
    ///   - showDivider: Whether to show a divider after the section
    ///   - dividerStyle: The style of the divider
    ///   - header: Optional header content
    ///   - footer: Optional footer content
    ///   - content: The main content
    public init(
        style: SectionStyle = .default,
        spacing: CGFloat = DesignTokens.Spacing.md,
        padding: EdgeInsets = EdgeInsets(
            top: DesignTokens.Spacing.lg,
            leading: DesignTokens.Spacing.lg,
            bottom: DesignTokens.Spacing.lg,
            trailing: DesignTokens.Spacing.lg
        ),
        background: SectionBackground = .surface,
        border: SectionBorder = .none,
        cornerRadius: CGFloat = DesignTokens.BorderRadius.md,
        showDivider: Bool = false,
        dividerStyle: DividerStyle = .default,
        @ViewBuilder header: () -> Header? = { nil },
        @ViewBuilder footer: () -> Footer? = { nil },
        @ViewBuilder content: () -> Content
    ) {
        self.header = header()
        self.content = content()
        self.footer = footer()
        self.style = style
        self.spacing = spacing
        self.padding = padding
        self.background = background
        self.border = border
        self.cornerRadius = cornerRadius
        self.showDivider = showDivider
        self.dividerStyle = dividerStyle
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 0) {
            // Section content
            VStack(alignment: .leading, spacing: spacing) {
                // Header
                if let header = header {
                    header
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Content
                content
                
                // Footer
                if let footer = footer {
                    footer
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(padding)
            .background(backgroundView)
            .overlay(borderView)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            
            // Divider
            if showDivider {
                RRDivider(style: dividerStyle)
                    .padding(.top, DesignTokens.Spacing.md)
            }
        }
    }
    
    // MARK: - Computed Properties
    
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
}

// MARK: - Section Style

public enum SectionStyle {
    case `default`
    case compact
    case spacious
    case card
    case hero
    case custom
}

// MARK: - Section Background

public enum SectionBackground {
    case none
    case surface
    case surfaceVariant
    case background
    case primary
    case secondary
    case custom(Color)
    case gradient([Color])
}

// MARK: - Section Border

public enum SectionBorder {
    case none
    case outline
    case outlineVariant
    case primary
    case custom(Color, width: CGFloat)
}

// MARK: - Section Extensions

public extension RRSection where Header == EmptyView, Footer == EmptyView {
    
    /// Creates a simple section with only content
    init(
        style: SectionStyle = .default,
        spacing: CGFloat = DesignTokens.Spacing.md,
        padding: EdgeInsets = EdgeInsets(
            top: DesignTokens.Spacing.lg,
            leading: DesignTokens.Spacing.lg,
            bottom: DesignTokens.Spacing.lg,
            trailing: DesignTokens.Spacing.lg
        ),
        background: SectionBackground = .surface,
        border: SectionBorder = .none,
        cornerRadius: CGFloat = DesignTokens.BorderRadius.md,
        showDivider: Bool = false,
        dividerStyle: DividerStyle = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.header = nil
        self.content = content()
        self.footer = nil
        self.style = style
        self.spacing = spacing
        self.padding = padding
        self.background = background
        self.border = border
        self.cornerRadius = cornerRadius
        self.showDivider = showDivider
        self.dividerStyle = dividerStyle
    }
}

public extension RRSection where Footer == EmptyView {
    
    /// Creates a section with header and content
    init(
        style: SectionStyle = .default,
        spacing: CGFloat = DesignTokens.Spacing.md,
        padding: EdgeInsets = EdgeInsets(
            top: DesignTokens.Spacing.lg,
            leading: DesignTokens.Spacing.lg,
            bottom: DesignTokens.Spacing.lg,
            trailing: DesignTokens.Spacing.lg
        ),
        background: SectionBackground = .surface,
        border: SectionBorder = .none,
        cornerRadius: CGFloat = DesignTokens.BorderRadius.md,
        showDivider: Bool = false,
        dividerStyle: DividerStyle = .default,
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) {
        self.header = header()
        self.content = content()
        self.footer = nil
        self.style = style
        self.spacing = spacing
        self.padding = padding
        self.background = background
        self.border = border
        self.cornerRadius = cornerRadius
        self.showDivider = showDivider
        self.dividerStyle = dividerStyle
    }
}

// MARK: - Section Convenience Methods

public extension RRSection {
    
    /// Creates a card-style section
    static func card(
        spacing: CGFloat = DesignTokens.Spacing.md,
        padding: EdgeInsets = EdgeInsets(
            top: DesignTokens.Spacing.lg,
            leading: DesignTokens.Spacing.lg,
            bottom: DesignTokens.Spacing.lg,
            trailing: DesignTokens.Spacing.lg
        ),
        showDivider: Bool = false,
        @ViewBuilder header: () -> Header? = { nil },
        @ViewBuilder footer: () -> Footer? = { nil },
        @ViewBuilder content: () -> Content
    ) -> RRSection<Header, Content, Footer> {
        RRSection(
            style: .card,
            spacing: spacing,
            padding: padding,
            background: .surface,
            border: .outlineVariant,
            cornerRadius: DesignTokens.BorderRadius.lg,
            showDivider: showDivider,
            header: header,
            footer: footer,
            content: content
        )
    }
    
    /// Creates a compact section
    static func compact(
        padding: EdgeInsets = EdgeInsets(
            top: DesignTokens.Spacing.md,
            leading: DesignTokens.Spacing.md,
            bottom: DesignTokens.Spacing.md,
            trailing: DesignTokens.Spacing.md
        ),
        showDivider: Bool = true,
        @ViewBuilder header: () -> Header? = { nil },
        @ViewBuilder footer: () -> Footer? = { nil },
        @ViewBuilder content: () -> Content
    ) -> RRSection<Header, Content, Footer> {
        RRSection(
            style: .compact,
            spacing: DesignTokens.Spacing.sm,
            padding: padding,
            background: .surfaceVariant,
            border: .none,
            cornerRadius: DesignTokens.BorderRadius.sm,
            showDivider: showDivider,
            header: header,
            footer: footer,
            content: content
        )
    }
    
    /// Creates a hero section
    static func hero(
        spacing: CGFloat = DesignTokens.Spacing.lg,
        padding: EdgeInsets = EdgeInsets(
            top: DesignTokens.Spacing.xl,
            leading: DesignTokens.Spacing.xl,
            bottom: DesignTokens.Spacing.xl,
            trailing: DesignTokens.Spacing.xl
        ),
        showDivider: Bool = false,
        @ViewBuilder header: () -> Header? = { nil },
        @ViewBuilder footer: () -> Footer? = { nil },
        @ViewBuilder content: () -> Content
    ) -> RRSection<Header, Content, Footer> {
        RRSection(
            style: .hero,
            spacing: spacing,
            padding: padding,
            background: .primary,
            border: .none,
            cornerRadius: DesignTokens.BorderRadius.xl,
            showDivider: showDivider,
            header: header,
            footer: footer,
            content: content
        )
    }
}

// MARK: - Previews

#if DEBUG
struct RRSection_Previews: PreviewProvider {
    static var previews: some View {
        RRSectionPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRSection Examples")
    }
}

private struct RRSectionPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                RRLabel.title("Section Examples")
                
                // Basic sections
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Basic Sections", style: .subtitle, weight: .semibold)
                    
                    RRSection {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            RRLabel("Simple Section", style: .subtitle, weight: .semibold)
                            RRLabel("This is a simple section with just content", style: .body)
                        }
                    }
                    
                    RRSection(
                        header: {
                            RRLabel("Section with Header", style: .title, weight: .semibold)
                        }
                    ) {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            RRLabel("This section has a header", style: .body)
                            RRLabel("And some content below it", style: .body)
                        }
                    }
                    
                    RRSection(
                        header: {
                            RRLabel("Section with Header and Footer", style: .title, weight: .semibold)
                        },
                        footer: {
                            RRLabel("Footer content", style: .caption, color: .secondary)
                        }
                    ) {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            RRLabel("This section has both header and footer", style: .body)
                            RRLabel("With content in between", style: .body)
                        }
                    }
                }
                
                // Styled sections
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Styled Sections", style: .subtitle, weight: .semibold)
                    
                    RRSection(
                        background: .primary,
                        border: .none
                    ) {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            RRLabel("Primary Section", style: .subtitle, weight: .semibold, customColor: theme.colors.onPrimary)
                            RRLabel("This section has a primary background", style: .body, customColor: theme.colors.onPrimary)
                        }
                    }
                    
                    RRSection(
                        background: .gradient([theme.colors.primary, theme.colors.secondary]),
                        border: .primary,
                        cornerRadius: DesignTokens.BorderRadius.lg
                    ) {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            RRLabel("Gradient Section", style: .subtitle, weight: .semibold, customColor: theme.colors.onPrimary)
                            RRLabel("This section has a gradient background", style: .body, customColor: theme.colors.onPrimary)
                        }
                    }
                }
                
                // Section styles
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Section Styles", style: .subtitle, weight: .semibold)
                    
                    RRSection(
                        style: .card,
                        background: .surface,
                        border: .outlineVariant,
                        cornerRadius: DesignTokens.BorderRadius.lg,
                        header: {
                            RRLabel("Card Section", style: .title, weight: .semibold)
                        }
                    ) {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            RRLabel("This is a card-style section", style: .body)
                            RRLabel("With a header and content", style: .body)
                        }
                    }
                    
                    RRSection(
                        style: .compact,
                        spacing: DesignTokens.Spacing.sm,
                        background: .surfaceVariant,
                        showDivider: true,
                        header: {
                            RRLabel("Compact Section", style: .subtitle, weight: .semibold)
                        }
                    ) {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            RRLabel("This is a compact section", style: .body)
                            RRLabel("With minimal spacing", style: .body)
                        }
                    }
                    
                    RRSection(
                        style: .hero,
                        spacing: DesignTokens.Spacing.lg,
                        padding: EdgeInsets(
                            top: DesignTokens.Spacing.xl,
                            leading: DesignTokens.Spacing.xl,
                            bottom: DesignTokens.Spacing.xl,
                            trailing: DesignTokens.Spacing.xl
                        ),
                        background: .primary,
                        cornerRadius: DesignTokens.BorderRadius.xl,
                        header: {
                            RRLabel("Hero Section", style: .title, weight: .semibold, customColor: theme.colors.onPrimary)
                        }
                    ) {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            RRLabel("This is a hero-style section", style: .body, customColor: theme.colors.onPrimary)
                            RRLabel("With primary background and large padding", style: .body, customColor: theme.colors.onPrimary)
                        }
                    }
                }
                
                // Sections with dividers
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Sections with Dividers", style: .subtitle, weight: .semibold)
                    
                    RRSection(
                        showDivider: true,
                        header: {
                            RRLabel("Section 1", style: .subtitle, weight: .semibold)
                        }
                    ) {
                        RRLabel("Content for section 1", style: .body)
                    }
                    
                    RRSection(
                        showDivider: true,
                        header: {
                            RRLabel("Section 2", style: .subtitle, weight: .semibold)
                        }
                    ) {
                        RRLabel("Content for section 2", style: .body)
                    }
                    
                    RRSection(
                        header: {
                            RRLabel("Section 3", style: .subtitle, weight: .semibold)
                        }
                    ) {
                        RRLabel("Content for section 3", style: .body)
                    }
                }
            }
            .padding(DesignTokens.Spacing.md)
        }
    }
}
#endif
