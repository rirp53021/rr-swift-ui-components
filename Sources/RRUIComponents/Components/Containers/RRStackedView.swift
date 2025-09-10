import SwiftUI

/// A utility component for creating stacked views with consistent spacing and padding
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRStackedView<Content: View>: View {
    // MARK: - Properties
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let content: Content
    private let axis: Axis
    private let alignment: Alignment
    private let spacing: CGFloat?
    private let contentPadding: EdgeInsets
    private let backgroundColor: Color?
    private let cornerRadius: CGFloat?
    
    // MARK: - Initialization
    
    public init(
        axis: Axis = .vertical,
        alignment: Alignment = .center,
        spacing: CGFloat? = nil,
        contentPadding: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
        backgroundColor: Color? = nil,
        cornerRadius: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.axis = axis
        self.alignment = alignment
        self.spacing = spacing
        self.contentPadding = contentPadding
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }
    
    // MARK: - Body
    
    public var body: some View {
        Group {
            switch axis {
            case .horizontal:
                HStack(alignment: .center, spacing: spacing) {
                    content
                }
            case .vertical:
                VStack(alignment: .center, spacing: spacing) {
                    content
                }
            }
        }
        .background(backgroundColor)
        .cornerRadius(cornerRadius ?? 0)
    }
}

// MARK: - Convenience Initializers

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension RRStackedView {
    /// Creates a vertical stack with standard spacing
    static func vertical(
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat? = DesignTokens.Spacing.md,
        contentPadding: EdgeInsets = EdgeInsets(top: DesignTokens.Spacing.md, leading: DesignTokens.Spacing.md, bottom: DesignTokens.Spacing.md, trailing: DesignTokens.Spacing.md),
        backgroundColor: Color? = nil,
        cornerRadius: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) -> RRStackedView {
        RRStackedView(
            axis: .vertical,
            alignment: Alignment(horizontal: alignment, vertical: .center),
            spacing: spacing,
            contentPadding: contentPadding,
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            content: content
        )
    }
    
    /// Creates a horizontal stack with standard spacing
    static func horizontal(
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = DesignTokens.Spacing.sm,
        contentPadding: EdgeInsets = EdgeInsets(top: DesignTokens.Spacing.sm, leading: DesignTokens.Spacing.sm, bottom: DesignTokens.Spacing.sm, trailing: DesignTokens.Spacing.sm),
        backgroundColor: Color? = nil,
        cornerRadius: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) -> RRStackedView {
        RRStackedView(
            axis: .horizontal,
            alignment: Alignment(horizontal: .center, vertical: alignment),
            spacing: spacing,
            contentPadding: contentPadding,
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            content: content
        )
    }
}

// MARK: - Spacing Utilities (Legacy Support)

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRSpacing {
    /// Standard spacing values - Use DesignTokens.Spacing instead
    @available(*, deprecated, message: "Use DesignTokens.Spacing instead")
    public static let xs: CGFloat = 4
    @available(*, deprecated, message: "Use DesignTokens.Spacing instead")
    public static let sm: CGFloat = 8
    @available(*, deprecated, message: "Use DesignTokens.Spacing instead")
    public static let md: CGFloat = 16
    @available(*, deprecated, message: "Use DesignTokens.Spacing instead")
    public static let lg: CGFloat = 24
    @available(*, deprecated, message: "Use DesignTokens.Spacing instead")
    public static let xl: CGFloat = 32
    @available(*, deprecated, message: "Use DesignTokens.Spacing instead")
    public static let xxl: CGFloat = 48
    
    /// Padding presets - Use DesignTokens.Spacing instead
    @available(*, deprecated, message: "Use DesignTokens.Spacing instead")
    public static let paddingXS = EdgeInsets(top: xs, leading: xs, bottom: xs, trailing: xs)
    @available(*, deprecated, message: "Use DesignTokens.Spacing instead")
    public static let paddingSM = EdgeInsets(top: sm, leading: sm, bottom: sm, trailing: sm)
    @available(*, deprecated, message: "Use DesignTokens.Spacing instead")
    public static let paddingMD = EdgeInsets(top: md, leading: md, bottom: md, trailing: md)
    @available(*, deprecated, message: "Use DesignTokens.Spacing instead")
    public static let paddingLG = EdgeInsets(top: lg, leading: lg, bottom: lg, trailing: lg)
    @available(*, deprecated, message: "Use DesignTokens.Spacing instead")
    public static let paddingXL = EdgeInsets(top: xl, leading: xl, bottom: xl, trailing: xl)
    
    /// Horizontal padding presets - Use DesignTokens.Spacing instead
    @available(*, deprecated, message: "Use DesignTokens.Spacing instead")
    public static let paddingHorizontalXS = EdgeInsets(top: 0, leading: xs, bottom: 0, trailing: xs)
    @available(*, deprecated, message: "Use DesignTokens.Spacing instead")
    public static let paddingHorizontalSM = EdgeInsets(top: 0, leading: sm, bottom: 0, trailing: sm)
    @available(*, deprecated, message: "Use DesignTokens.Spacing instead")
    public static let paddingHorizontalMD = EdgeInsets(top: 0, leading: md, bottom: 0, trailing: md)
    @available(*, deprecated, message: "Use DesignTokens.Spacing instead")
    public static let paddingHorizontalLG = EdgeInsets(top: 0, leading: lg, bottom: 0, trailing: lg)
    @available(*, deprecated, message: "Use DesignTokens.Spacing instead")
    public static let paddingHorizontalXL = EdgeInsets(top: 0, leading: xl, bottom: 0, trailing: xl)
    
    /// Vertical padding presets - Use DesignTokens.Spacing instead
    @available(*, deprecated, message: "Use DesignTokens.Spacing instead")
    public static let paddingVerticalXS = EdgeInsets(top: xs, leading: 0, bottom: xs, trailing: 0)
    @available(*, deprecated, message: "Use DesignTokens.Spacing instead")
    public static let paddingVerticalSM = EdgeInsets(top: sm, leading: 0, bottom: sm, trailing: 0)
    @available(*, deprecated, message: "Use DesignTokens.Spacing instead")
    public static let paddingVerticalMD = EdgeInsets(top: md, leading: 0, bottom: md, trailing: 0)
    @available(*, deprecated, message: "Use DesignTokens.Spacing instead")
    public static let paddingVerticalLG = EdgeInsets(top: lg, leading: 0, bottom: lg, trailing: 0)
    @available(*, deprecated, message: "Use DesignTokens.Spacing instead")
    public static let paddingVerticalXL = EdgeInsets(top: xl, leading: 0, bottom: xl, trailing: 0)
}

// MARK: - Spacer Utilities

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRSpacer {
    /// Creates a spacer with specific height
    public static func height(_ height: CGFloat) -> some View {
        Spacer()
            .frame(height: height)
    }
    
    /// Creates a spacer with specific width
    public static func width(_ width: CGFloat) -> some View {
        Spacer()
            .frame(width: width)
    }
    
    /// Creates a spacer with specific size
    public static func size(_ size: CGSize) -> some View {
        Spacer()
            .frame(width: size.width, height: size.height)
    }
}

// MARK: - Divider Utilities

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRDivider {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    /// Creates a horizontal divider with custom styling
    public static func horizontal(
        color: Color? = nil,
        thickness: CGFloat = 1,
        contentPadding: EdgeInsets = EdgeInsets(top: DesignTokens.Spacing.sm, leading: 0, bottom: DesignTokens.Spacing.sm, trailing: 0)
    ) -> some View {
        RRDividerView(
            color: color,
            thickness: thickness,
            contentPadding: contentPadding,
            isHorizontal: true
        )
    }
    
    /// Creates a vertical divider with custom styling
    public static func vertical(
        color: Color? = nil,
        thickness: CGFloat = 1,
        contentPadding: EdgeInsets = EdgeInsets(top: 0, leading: DesignTokens.Spacing.sm, bottom: 0, trailing: DesignTokens.Spacing.sm)
    ) -> some View {
        RRDividerView(
            color: color,
            thickness: thickness,
            contentPadding: contentPadding,
            isHorizontal: false
        )
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct RRDividerView: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    let color: Color?
    let thickness: CGFloat
    let contentPadding: EdgeInsets
    let isHorizontal: Bool
    
    private var effectiveColor: Color {
        color ?? theme.colors.outline
    }
    
    var body: some View {
        Rectangle()
            .fill(effectiveColor)
            .frame(
                width: isHorizontal ? nil : thickness,
                height: isHorizontal ? thickness : nil
            )
    }
}

// MARK: - Preview

#if DEBUG
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct RRStackedView_Previews: PreviewProvider {
    static var previews: some View {
        RRStackedViewPreview()
            .themeProvider(ThemeProvider())
            .previewDisplayName("RRStackedView Examples")
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct RRStackedViewPreview: View {
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    var body: some View {
        ScrollView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                // Vertical stacks
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Vertical Stacks", style: .subtitle, weight: .bold, color: .primary)
                    
                    RRStackedView.vertical(
                        alignment: .leading,
                        spacing: DesignTokens.Spacing.sm,
                        contentPadding: EdgeInsets(top: DesignTokens.Spacing.md, leading: DesignTokens.Spacing.md, bottom: DesignTokens.Spacing.md, trailing: DesignTokens.Spacing.md),
                        backgroundColor: theme.colors.surfaceVariant,
                        cornerRadius: DesignTokens.BorderRadius.md
                    ) {
                        RRLabel("Item 1", style: .body, weight: .regular, color: .primary)
                        RRLabel("Item 2", style: .body, weight: .regular, color: .primary)
                        RRLabel("Item 3", style: .body, weight: .regular, color: .primary)
                    }
                    
                    RRStackedView.vertical(
                        alignment: .center,
                        spacing: DesignTokens.Spacing.md,
                        contentPadding: EdgeInsets(top: DesignTokens.Spacing.lg, leading: DesignTokens.Spacing.lg, bottom: DesignTokens.Spacing.lg, trailing: DesignTokens.Spacing.lg)
                    ) {
                        Image(systemName: "star.fill")
                            .foregroundColor(theme.colors.warning)
                        RRLabel("Centered Content", style: .subtitle, weight: .bold, color: .primary)
                        RRLabel("With proper spacing", style: .body, weight: .regular, color: .secondary)
                    }
                }
                
                // Horizontal stacks
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Horizontal Stacks", style: .subtitle, weight: .bold, color: .primary)
                    
                    RRStackedView.horizontal(
                        alignment: .center,
                        spacing: DesignTokens.Spacing.sm,
                        contentPadding: EdgeInsets(top: DesignTokens.Spacing.md, leading: DesignTokens.Spacing.md, bottom: DesignTokens.Spacing.md, trailing: DesignTokens.Spacing.md),
                        backgroundColor: theme.colors.surfaceVariant,
                        cornerRadius: DesignTokens.BorderRadius.md
                    ) {
                        Image(systemName: "person.circle")
                        RRLabel("User Name", style: .body, weight: .regular, color: .primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    
                    RRStackedView.horizontal(
                        alignment: .top,
                        spacing: DesignTokens.Spacing.sm,
                        contentPadding: EdgeInsets(top: DesignTokens.Spacing.sm, leading: DesignTokens.Spacing.sm, bottom: DesignTokens.Spacing.sm, trailing: DesignTokens.Spacing.sm)
                    ) {
                        VStack(alignment: .leading) {
                            RRLabel("Title", style: .subtitle, weight: .bold, color: .primary)
                            RRLabel("Subtitle", style: .caption, weight: .regular, color: .secondary)
                        }
                        Spacer()
                        Button("Action") { }
                    }
                }
                
                // Spacing examples
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Spacing Utilities", style: .subtitle, weight: .bold, color: .primary)
                    
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                        RRLabel("Different spacing values:", style: .body, weight: .regular, color: .primary)
                        HStack {
                            RRLabel("XS", style: .caption, weight: .regular, color: .primary)
                            RRSpacer.width(DesignTokens.Spacing.xs)
                            Rectangle()
                                .fill(theme.colors.primary)
                                .frame(width: DesignTokens.ComponentSize.iconSizeMD, height: DesignTokens.ComponentSize.iconSizeMD)
                        }
                        HStack {
                            RRLabel("SM", style: .caption, weight: .regular, color: .primary)
                            RRSpacer.width(DesignTokens.Spacing.sm)
                            Rectangle()
                                .fill(theme.colors.primary)
                                .frame(width: DesignTokens.ComponentSize.iconSizeMD, height: DesignTokens.ComponentSize.iconSizeMD)
                        }
                        HStack {
                            RRLabel("MD", style: .caption, weight: .regular, color: .primary)
                            RRSpacer.width(DesignTokens.Spacing.md)
                            Rectangle()
                                .fill(theme.colors.primary)
                                .frame(width: DesignTokens.ComponentSize.iconSizeMD, height: DesignTokens.ComponentSize.iconSizeMD)
                        }
                        HStack {
                            RRLabel("LG", style: .caption, weight: .regular, color: .primary)
                            RRSpacer.width(DesignTokens.Spacing.lg)
                            Rectangle()
                                .fill(theme.colors.primary)
                                .frame(width: DesignTokens.ComponentSize.iconSizeMD, height: DesignTokens.ComponentSize.iconSizeMD)
                        }
                    }
                    .padding(EdgeInsets(top: DesignTokens.Spacing.md, leading: DesignTokens.Spacing.md, bottom: DesignTokens.Spacing.md, trailing: DesignTokens.Spacing.md))
                    .background(theme.colors.surfaceVariant)
                    .cornerRadius(DesignTokens.BorderRadius.md)
                }
                
                // Divider examples
                VStack(spacing: DesignTokens.Spacing.md) {
                    RRLabel("Divider Utilities", style: .subtitle, weight: .bold, color: .primary)
                    
                    VStack {
                        RRLabel("Section 1", style: .body, weight: .regular, color: .primary)
                        RRDivider.horizontal()
                        RRLabel("Section 2", style: .body, weight: .regular, color: .primary)
                        RRDivider.horizontal(color: theme.colors.error, thickness: 2)
                        RRLabel("Section 3", style: .body, weight: .regular, color: .primary)
                    }
                    .padding(EdgeInsets(top: DesignTokens.Spacing.md, leading: DesignTokens.Spacing.md, bottom: DesignTokens.Spacing.md, trailing: DesignTokens.Spacing.md))
                    .background(theme.colors.surfaceVariant)
                    .cornerRadius(DesignTokens.BorderRadius.md)
                }
            }
        }
    }
}
#endif
