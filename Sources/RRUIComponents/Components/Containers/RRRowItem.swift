import SwiftUI

/// A reusable row item component for lists with configurable left icon, text, and right accessory
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RRRowItem<LeftIcon: View, RightAccessory: View>: View {
    // MARK: - Properties
    
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
        padding: EdgeInsets = EdgeInsets(top: RRSpacing.sm, leading: RRSpacing.md, bottom: RRSpacing.sm, trailing: RRSpacing.md),
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
        self.backgroundColor = backgroundColor ?? style.backgroundColor
        self.separatorColor = separatorColor ?? style.separatorColor
        self.showSeparator = showSeparator
        self.action = action
        self.leftIcon = leftIcon?()
        self.rightAccessory = rightAccessory?()
    }
    
    // MARK: - Body
    
    public var body: some View {
        Button(action: action ?? {}) {
            HStack(spacing: RRSpacing.sm) {
                // Left icon
                if let leftIcon = leftIcon {
                    leftIcon
                        .foregroundColor(style.leftIconColor)
                        .frame(width: 24, height: 24)
                }
                
                // Content
                VStack(alignment: .leading, spacing: RRSpacing.xs) {
                    Text(title)
                        .font(style.titleFont)
                        .foregroundColor(style.titleColor)
                        .multilineTextAlignment(.leading)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(style.subtitleFont)
                            .foregroundColor(style.subtitleColor)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                // Right accessory
                if let rightAccessory = rightAccessory {
                    rightAccessory
                        .foregroundColor(style.rightAccessoryColor)
                }
            }
            .padding(padding)
            .background(backgroundColor)
        }
        .buttonStyle(PlainButtonStyle())
        .overlay(
            VStack {
                Spacer()
                if showSeparator {
                    Rectangle()
                        .fill(separatorColor)
                        .frame(height: 0.5)
                        .padding(.leading, leftIcon != nil ? 52 : padding.leading)
                }
            }
        )
    }
}

// MARK: - Row Style

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension RRRowItem {
    enum RowStyle {
        case standard
        case compact
        case prominent
        case destructive
        
        var titleFont: Font {
            switch self {
            case .standard, .compact:
                return .body
            case .prominent:
                return .headline
            case .destructive:
                return .body
            }
        }
        
        var subtitleFont: Font {
            switch self {
            case .standard, .compact, .prominent:
                return .caption
            case .destructive:
                return .caption
            }
        }
        
        var titleColor: Color {
            switch self {
            case .standard, .compact, .prominent:
                return .primary
            case .destructive:
                return .red
            }
        }
        
        var subtitleColor: Color {
            switch self {
            case .standard, .compact, .prominent:
                return .secondary
            case .destructive:
                return .red.opacity(0.8)
            }
        }
        
        var leftIconColor: Color {
            switch self {
            case .standard, .compact, .prominent:
                return .blue
            case .destructive:
                return .red
            }
        }
        
        var rightAccessoryColor: Color {
            switch self {
            case .standard, .compact, .prominent:
                return .secondary
            case .destructive:
                return .red
            }
        }
        
        var backgroundColor: Color {
            return Color(.systemBackground)
        }
        
        var separatorColor: Color {
            return Color(.separator)
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
        padding: EdgeInsets = EdgeInsets(top: RRSpacing.sm, leading: RRSpacing.md, bottom: RRSpacing.sm, trailing: RRSpacing.md),
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
        padding: EdgeInsets = EdgeInsets(top: RRSpacing.sm, leading: RRSpacing.md, bottom: RRSpacing.sm, trailing: RRSpacing.md),
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
        padding: EdgeInsets = EdgeInsets(top: RRSpacing.sm, leading: RRSpacing.md, bottom: RRSpacing.sm, trailing: RRSpacing.md),
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
        .previewDisplayName("RRRowItem Examples")
    }
}
#endif