import SwiftUI

/// A reusable row item component for lists with configurable left icon, text, and right accessory
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRRowItem<LeftIcon: View, RightAccessory: View>: View {
    // MARK: - Properties
    
    @Environment(\.themeProvider) private var themeProvider
    private var theme: Theme { themeProvider.currentTheme }
    
    private let title: String
    private let subtitle: String?
    private let leftIcon: LeftIcon?
    private let rightAccessory: RightAccessory?
    private let style: RowStyle
    private let padding: EdgeInsets
    private let backgroundColor: Color
    private let separatorColor: Color
    private let showSeparator: Bool
    private let action: (() -> Void)?
    
    // MARK: - Initialization
    
    public init(
        title: String,
        subtitle: String? = nil,
        style: RowStyle = .standard,
        padding: EdgeInsets = EdgeInsets(top: DesignTokens.Spacing.sm, leading: DesignTokens.Spacing.md, bottom: DesignTokens.Spacing.sm, trailing: DesignTokens.Spacing.md),
        backgroundColor: Color? = nil,
        separatorColor: Color? = nil,
        showSeparator: Bool = true,
        action: (() -> Void)? = nil,
        leftIcon: (() -> LeftIcon)? = nil,
        rightAccessory: (() -> RightAccessory)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.padding = padding
        self.backgroundColor = backgroundColor ?? Color.clear // Will be set in body using theme
        self.separatorColor = separatorColor ?? Color.clear // Will be set in body using theme
        self.showSeparator = showSeparator
        self.action = action
        self.leftIcon = leftIcon?()
        self.rightAccessory = rightAccessory?()
    }
    
    // MARK: - Body
    
    public var body: some View {
        Button(action: action ?? {}) {
            HStack(spacing: DesignTokens.Spacing.sm) {
                // Left icon
                if let leftIcon = leftIcon {
                    leftIcon
                        .foregroundColor(style.leftIconColor(theme: theme))
                        .frame(width: DesignTokens.ComponentSize.iconSizeMD, height: DesignTokens.ComponentSize.iconSizeMD)
                }
                
                // Content
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    RRLabel(title, style: style.titleLabelStyle, weight: .medium, customColor: style.titleColor(theme: theme))
                        .multilineTextAlignment(.leading)
                    
                    if let subtitle = subtitle {
                        RRLabel(subtitle, style: style.subtitleLabelStyle, weight: .regular, customColor: style.subtitleColor(theme: theme))
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                // Right accessory
                if let rightAccessory = rightAccessory {
                    rightAccessory
                        .foregroundColor(style.rightAccessoryColor(theme: theme))
                }
            }
            .padding(padding)
            .background(backgroundColor == Color.clear ? style.backgroundColor(theme: theme) : backgroundColor)
        }
        .buttonStyle(PlainButtonStyle())
        .overlay(
            VStack {
                Spacer()
                if showSeparator {
                    Rectangle()
                        .fill(separatorColor == Color.clear ? style.separatorColor(theme: theme) : separatorColor)
                        .frame(height: 1)
                        .padding(.leading, leftIcon != nil ? DesignTokens.ComponentSize.iconSizeMD + DesignTokens.Spacing.md : padding.leading)
                }
            }
        )
    }
}

// MARK: - Row Style

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension RRRowItem {
    @MainActor
    enum RowStyle {
        case standard
        case compact
        case prominent
        case destructive
        
        var titleLabelStyle: RRLabel.Style {
            switch self {
            case .standard, .compact:
                return .body
            case .prominent:
                return .subtitle
            case .destructive:
                return .body
            }
        }
        
        var subtitleLabelStyle: RRLabel.Style {
            switch self {
            case .standard, .compact, .prominent:
                return .caption
            case .destructive:
                return .caption
            }
        }
        
        func titleColor(theme: Theme) -> Color {
            switch self {
            case .standard, .compact, .prominent:
                return theme.colors.primaryText
            case .destructive:
                return theme.colors.error
            }
        }
        
        func subtitleColor(theme: Theme) -> Color {
            switch self {
            case .standard, .compact, .prominent:
                return theme.colors.secondaryText
            case .destructive:
                return theme.colors.error.opacity(0.8)
            }
        }
        
        func leftIconColor(theme: Theme) -> Color {
            switch self {
            case .standard, .compact, .prominent:
                return theme.colors.primary
            case .destructive:
                return theme.colors.error
            }
        }
        
        func rightAccessoryColor(theme: Theme) -> Color {
            switch self {
            case .standard, .compact, .prominent:
                return theme.colors.onSurfaceVariant
            case .destructive:
                return theme.colors.error
            }
        }
        
        func backgroundColor(theme: Theme) -> Color {
            return theme.colors.surface
        }
        
        func separatorColor(theme: Theme) -> Color {
            return theme.colors.outline
        }
    }
}

// MARK: - Convenience Initializers

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension RRRowItem where LeftIcon == EmptyView, RightAccessory == EmptyView {
    init(
        title: String,
        subtitle: String? = nil,
        style: RowStyle = .standard,
        padding: EdgeInsets = EdgeInsets(top: DesignTokens.Spacing.sm, leading: DesignTokens.Spacing.md, bottom: DesignTokens.Spacing.sm, trailing: DesignTokens.Spacing.md),
        backgroundColor: Color? = nil,
        separatorColor: Color? = nil,
        showSeparator: Bool = true,
        action: (() -> Void)? = nil
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            style: style,
            padding: padding,
            backgroundColor: backgroundColor,
            separatorColor: separatorColor,
            showSeparator: showSeparator,
            action: action,
            leftIcon: nil,
            rightAccessory: nil
        )
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension RRRowItem where RightAccessory == EmptyView {
    init(
        title: String,
        subtitle: String? = nil,
        style: RowStyle = .standard,
        padding: EdgeInsets = EdgeInsets(top: DesignTokens.Spacing.sm, leading: DesignTokens.Spacing.md, bottom: DesignTokens.Spacing.sm, trailing: DesignTokens.Spacing.md),
        backgroundColor: Color? = nil,
        separatorColor: Color? = nil,
        showSeparator: Bool = true,
        action: (() -> Void)? = nil,
        @ViewBuilder leftIcon: @escaping () -> LeftIcon
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            style: style,
            padding: padding,
            backgroundColor: backgroundColor,
            separatorColor: separatorColor,
            showSeparator: showSeparator,
            action: action,
            leftIcon: leftIcon,
            rightAccessory: nil
        )
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension RRRowItem where LeftIcon == EmptyView {
    init(
        title: String,
        subtitle: String? = nil,
        style: RowStyle = .standard,
        padding: EdgeInsets = EdgeInsets(top: DesignTokens.Spacing.sm, leading: DesignTokens.Spacing.md, bottom: DesignTokens.Spacing.sm, trailing: DesignTokens.Spacing.md),
        backgroundColor: Color? = nil,
        separatorColor: Color? = nil,
        showSeparator: Bool = true,
        action: (() -> Void)? = nil,
        @ViewBuilder rightAccessory: @escaping () -> RightAccessory
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            style: style,
            padding: padding,
            backgroundColor: backgroundColor,
            separatorColor: separatorColor,
            showSeparator: showSeparator,
            action: action,
            leftIcon: nil,
            rightAccessory: rightAccessory
        )
    }
}

// MARK: - Preview

#if DEBUG
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct RRRowItem_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Section("Basic Rows") {
                RRRowItem(
                    title: "Basic Row",
                    subtitle: "With subtitle"
                )
                
                RRRowItem(
                    title: "Row with Icon",
                    subtitle: "Has a left icon",
                    leftIcon: {
                        Image(systemName: "person.circle")
                    }
                )
                
                RRRowItem(
                    title: "Row with Accessory",
                    subtitle: "Has a right accessory",
                    rightAccessory: {
                        Image(systemName: "chevron.right")
                    }
                )
            }
            
            Section("Styled Rows") {
                RRRowItem(
                    title: "Prominent Row",
                    subtitle: "Larger text",
                    style: .prominent,
                    leftIcon: {
                        Image(systemName: "star.fill")
                    },
                    rightAccessory: {
                        Image(systemName: "chevron.right")
                    }
                )
                
                RRRowItem(
                    title: "Destructive Row",
                    subtitle: "Red styling",
                    style: .destructive,
                    leftIcon: {
                        Image(systemName: "trash")
                    },
                    rightAccessory: {
                        Image(systemName: "chevron.right")
                    }
                )
            }
            
            Section("Interactive Rows") {
                RRRowItem(
                    title: "Settings",
                    subtitle: "App preferences",
                    action: {
                        print("Settings tapped")
                    },
                    leftIcon: {
                        Image(systemName: "gear")
                    },
                    rightAccessory: {
                        Image(systemName: "chevron.right")
                    }
                )
                
                RRRowItem(
                    title: "Notifications",
                    subtitle: "Push notifications",
                    action: {
                        print("Notifications toggled")
                    },
                    leftIcon: {
                        Image(systemName: "bell")
                    },
                    rightAccessory: {
                        Toggle("", isOn: .constant(true))
                    }
                )
            }
        }
        .themeProvider(ThemeProvider())
        .previewDisplayName("RRRowItem Examples")
    }
}
#endif
